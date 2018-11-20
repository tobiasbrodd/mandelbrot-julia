module Mandelbrot

using Gadfly, PyPlot, Plots

function mandelbrot(z, max_iter)
    c = z
    for n in 0:(max_iter-1)
        if abs(z) > 2
            return n
        end
        z = z*z + c
    end
    return max_iter
end

function mandelbrot_set(x_min, x_max, y_min, y_max, width, height, max_iter)
    r1 = collect(LinRange(x_min, x_max, width))
    r2 = collect(LinRange(y_min, y_max, height))
    n3 = zeros((width, height))

    for i in 1:width, j in 1:height
        n3[i,j] = mandelbrot(r1[i] + r2[j]im, max_iter)
    end

    return (r1, r2, n3)
end

function mandelbrot_image(x_min, x_max, y_min, y_max; width=10, height=10, max_iter=80, backend="gadfly")
    dpi = 72
    img_width = 72width
    img_height = 72height
    _, _, z = mandelbrot_set(x_min, x_max, y_min, y_max, img_width, img_height, max_iter)
    z = collect(transpose(z))

    if backend == "gadfly"
        gadfly_plot(z, width, height)
    elseif backend == "pyplot"
        pyplot_plot(z, width, height, dpi)
    else
        plots_plot(z, width, height, dpi)
    end
end

function gadfly_plot(z, width, height)
    s = Gadfly.spy(z, Guide.xticks(ticks=nothing), Guide.yticks(ticks=nothing), Guide.xlabel(nothing), Guide.ylabel(nothing))
    Gadfly.draw(SVG("plots/mandelbrot_gadfly.svg", width*inch, height*inch), s)
    # display(s)
end

function pyplot_plot(z, width, height, dpi)
    fig = figure(figsize=(width, height), dpi=72)

    axis("off")
    imshow(z, cmap="viridis", origin="lower")
    PyPlot.savefig("plots/mandelbrot_pyplot.png")
    # show()
end

function plots_plot(z, width, height, dpi)
    gr()
    hm = heatmap(z, c=:viridis, size=(width*dpi, height*dpi), dpi=dpi, aspect_ratio=:equal, xaxis=false, yaxis=false, legend=false)
    png(hm, "plots/mandelbrot_plots.png")
    # display(hm)
end

mandelbrot_image(-2.0, 0.5, -1.25, 1.25, backend="pyplot")

end