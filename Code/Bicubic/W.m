function value = W(x)
    absx = abs(x);
    if (absx <= 1)
        value = double(1.5 * (absx^3) - 2.5 * (absx^2) + 1);
    elseif (1 < absx && absx <= 2)
        value = double(-0.5 * (absx^3) + 2.5 * (absx^2) - 4 * absx + 2);
    else
        value = 0;
    end
end

