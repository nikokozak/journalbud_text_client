defmodule TextClient.Types do

  @type http_code :: 200 | 201 | 204 | 401 | 404 | 405 | 408 | 422 | 500
  @type api_code :: 2 | 9 | 10 | 20 | 21 | 25 | 98 | 99 | 100 | 101 | 102
  @type descriptor :: :api_request_not_allowed | :api_missing_parameters | :api_invalid_parameters |
  :api_not_found | :api_bad_request | :api_not_enough_balance | :api_not_found | :api_internal_error |
  :api_service_unavailable | :api_duplicate_entry | :api_ambiguous_lookup | :http_found | :http_created |
  :http_empty | :http_access_key_incorrect | :http_not_found | :http_method_not_allowed | :http_timeout |
  :http_not_created | :http_server_error

  @type contact_req :: %{
    msisdn: String.t, # Phone number of contact
    firstName: String.t, # Optional
    lastName: String.t, # Optional
    custom1: String.t # Email of contact
  }

  @type contact_res :: %{
    id: String.t,
    href: String.t,
    msisdn: String.t,
    firstName: String.t,
    lastName: String.t,
    customDetails: %{
      custom1: String.t,
      custom2: String.t,
      custom3: String.t,
      custom4: String.t
    },
    groups: %{
      totalCount: integer,
      href: String.t
    },
    messages: %{
      totalCount: integer,
      href: String.t
    }
  }

  ########################################

  @spec code_to_message(http_code | api_code) :: String.t
  def code_to_message(code) do
    {message, _code} = rosetta(code)

    message
  end

  @spec code_to_descriptor(http_code | api_code) :: descriptor
  def code_to_descriptor(code) do
    {_message, descriptor} = rosetta(code)

    descriptor
  end

  ########################################

  @spec rosetta(http_code | api_code) :: {String.t, atom}
  defp rosetta(code) when is_integer(code) do
    %{
      2   => {"Request not allowed", :api_request_not_allowed},
      9   => {"Missing params", :api_missing_parameters},
      10  => {"Invalid params", :api_invalid_parameters},
      20  => {"Not found", :api_not_found},
      21  => {"Bad request", :api_bad_request},
      25  => {"Not enough balance", :api_not_enough_balance},
      98  => {"API not found", :api_not_found},
      99  => {"Internal error", :api_internal_error},
      100 => {"Service unavailable", :api_service_unavailable},
      101 => {"Duplicate entry", :api_duplicate_entry},
      102 => {"Ambiguous lookup", :api_ambiguous_lookup},
      200 => {"We found the resource", :http_found},
      201 => {"The resource is succesfully created", :http_created},
      204 => {"The requested resource is empty", :http_empty},
      401 => {"Access key was incorrect", :http_access_key_incorrect},
      404 => {"The resources cannot be found", :http_not_found},
      405 => {"The method is not allowed", :http_method_not_allowed},
      408 => {"The request is taking too long to respond", :http_timeout},
      422 => {"The resource couldn't be created", :http_not_created},
      500 => {"API Server Error, try again", :http_server_error}
    } |> Map.fetch!(code)
  end

end
