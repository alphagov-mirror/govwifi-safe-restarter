module UseCase
  class HealthCheck
    def initialize(route53_gateway: Gateways::Route53.new)
      @route53_gateway = route53_gateway
    end

    def execute
      health_checks.map do |health_check|
        status(route53_gateway.get_health_check_status(health_check_id: health_check.id))
      end.all?
    end

    private

    attr_reader :route53_gateway

    SUCCESS_STATUS = 'Success: HTTP Status Code 200, OK'.freeze

    def status(health_check)
      all_health_checkers_healthy?(health_check)
    end

    def all_health_checkers_healthy?(health_check)
      health_check.health_check_observations.all? do |a|
        a.status_report.status == SUCCESS_STATUS
      end
    end

    def health_checks
      @health_checks ||= route53_gateway.list_health_checks.health_checks
    end
  end
end