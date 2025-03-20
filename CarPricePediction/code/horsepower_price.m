veri = readtable('7_CarPrice_Assignment.csv');
fiyat = veri.price;
beygir_gucu = veri.horsepower;
X = [ones(length(beygir_gucu), 1) beygir_gucu]; 
b = X \ fiyat;
tahminler = X * b;

SS_toplam = sum((fiyat - mean(fiyat)).^2);
SS_hata = sum((fiyat - tahminler).^2);
R_kare = 1 - (SS_hata / SS_toplam);
MSE = mean((fiyat - tahminler).^2);

fprintf('Doğrusal regresyon denklemi: fiyat = %.2f + %.2f * beygir gücü\n', b(1), b(2));
fprintf('R-kare değeri: %.4f\n', R_kare);
fprintf('Ortalama Kare Hata (MSE): %.2f\n', MSE);

beygir_gucu_degeri = 250;
tahmin_edilen_fiyat = [1 beygir_gucu_degeri] * b;
fprintf('250 beygir gücüne sahip bir araba için tahmin edilen fiyat: %.2f\n', tahmin_edilen_fiyat);

% Grafik çizimi
figure;
scatter(beygir_gucu, fiyat, 'filled');
hold on;
plot(beygir_gucu, X * b);

scatter(beygir_gucu_degeri, tahmin_edilen_fiyat, 'filled', 'MarkerFaceColor', 'g');
line([beygir_gucu_degeri beygir_gucu_degeri], [0 tahmin_edilen_fiyat], 'Color', 'g', 'LineStyle', '-');
line([0 beygir_gucu_degeri], [tahmin_edilen_fiyat tahmin_edilen_fiyat], 'Color', 'g', 'LineStyle', '-');

xlabel('Beygir Gücü');
ylabel('Fiyat');
title(sprintf('Beygir Gücüne Göre Fiyatın Doğrusal Regresyonu'));
legend('Veri', 'Regresyon Doğrusu', '250 BG için Tahmin Edilen Fiyat');
hold off;