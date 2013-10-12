module ApplicationHelper
  def edit_and_destroy_buttons(item)
    if signed_in?
      edit = link_to('edit', url_for([:edit, item]), class: "btn")
      del = link_to('Destroy', item, method: :delete,
                    data: {confirm: 'Are you sure?'}, class: "btn btn-danger")
      raw("#{edit} #{del}")
    end
  end

  def round(decimal)
    with_precision = number_with_precision(decimal, precision: 1)
    raw("#{with_precision}")
  end
end
