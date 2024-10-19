Received: from outbound1g.eu.mailhop.org (outbound1g.eu.mailhop.org [52.28.6.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03618755C
	for <linux-raid@vger.kernel.org>; Sat, 19 Oct 2024 10:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=52.28.6.212
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729332306; cv=pass; b=CHjRuzosvyFCJY8t/8RnOWlqpcLzlWShzn4wy8I4mkYh9K5FG0AJqKPqwQ2LVXRrEvlBaXx7LVZD/m1yhNgR6ZwFnJgE3VP+7jIjBlYUdIIWe0AQU8fxVw6tLiuBcQ4/7gs6tLsGkqmZbOlBrQAAhmuOC/K1wmYDVVKsMZ+JrkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729332306; c=relaxed/simple;
	bh=2Vt91yDKKTHfLXKK8JAw8gQoKHDdHncG+S+a7GzXWBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bwGi0Nh8f4QDcTNHtkm/VN4m33ZIotZY2IKXDfIe85uF4QJycxMLsOQicG0UjojeM4OciKfk2LoclFVQAc7H/ElYlrt2EBQ2/rtwBtfNw3EcMokNLlmDcmCnXRCZwHBgVHffJu6WM5v3Hd7E7TuuOjotH9IMXfxCOpw9td0Wa4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk; spf=pass smtp.mailfrom=demonlair.co.uk; dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b=ZbhOD12L; arc=pass smtp.client-ip=52.28.6.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=demonlair.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outbound.mailhop.org header.i=@outbound.mailhop.org header.b="ZbhOD12L"
ARC-Seal: i=1; a=rsa-sha256; t=1729332236; cv=none;
	d=outbound.mailhop.org; s=arc-outbound20181012;
	b=bK57kzWPyO39ZVqW2YFcrKUICvk0VHp3FpC4lcuB8ImTP1AobWUm/vC8CqlmsrEGCAAYYyr8qJRvj
	 M/Ov41AQwaQtdXE9Kh3Jv+ynq7wvKzM6E0vGMSWePlq2yBqTym/3iZQ1gt3M+afeeUYTAjsna/XV98
	 J5eARUzTRU6a/CLj2w1t3Z6ocmAx6dJk7tbBGd7NgeY/AHrW/c9+5JnyI88Ww6k+cnQy+dBuz2Grbk
	 9IHhF7zhoZ/k6LVMc9YJvunpY5Iv+bKAYMf5LEQR20i9rXdKIxdQeNwZHZjHxHLQv6+Vlamso6OH6l
	 LE++iS1tpRyJsWS5wAunxW9j7oVnHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=outbound.mailhop.org; s=arc-outbound20181012;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
	 mime-version:date:message-id:dkim-signature:from;
	bh=YMZ62Y+AOFwwN0XWMgHLsH1EkLN8GmVSV6CHleaNwek=;
	b=J2tmXJEo4xqrFgjlyOeeMovOK77pGaIwbvfAxagDiNhF20Ttpgy9PWUXVTLmntn5IuNYt5oqt1ujp
	 Zc0IfzLZ5GWA9zHCqCkJaBepiKsFYHKL0ueN1J+B/X9BIozioFm3A1bWSsAxkwxVHoye6ewFe1XGx2
	 3CkVyhtAh8bf+f3apD6Zvy0NyYCFEeRJSI2AK2BtR19lT+HRyn7aEvOp6WfFHxYS9pmf1gHUt7/28D
	 7jzNCoEj4bai+gb7MB9M3a1nWQzsijn/glfwmhyyvREKNcrxAVUDA7nVqFKVhEUHyr9v6+PCWxNQbc
	 I7m8dZ1dy/eO8DKNZkPGDi9tfcVTHwg==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
	spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=217.43.3.134;
	dmarc=none header.from=demonlair.co.uk;
	arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=outbound.mailhop.org; s=dkim-high;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
	 mime-version:date:message-id:from;
	bh=YMZ62Y+AOFwwN0XWMgHLsH1EkLN8GmVSV6CHleaNwek=;
	b=ZbhOD12Lt74pCF9spP/+WO0gugHAXukUjxRR+OpdEvmA4tBcAjU9uT/RoCJo2SKCyiKD5WVZT1Mh1
	 W3e73agUXpObFexKoMLBZw8O3Mr9QoJZjkyDrCx901jF5+GpXeZmM0TYs0/0KLHupdNuai62ijCf54
	 7V3VCVwYuU7Z6h8r3HOWXbyrisxiSGzfgnaTu/s9a8eTGk2O/KLfJ4lTPAMlowNQ5D5RmXRsEktVbi
	 2WhILAno2wjjUobfqLFsCPfnjiGbQGl9Io4bvbpXsIXGZKXIg7NLcw5J3Xr0Quo5PyNUDNM8H23pKH
	 Lz0Gh6i8fX4sFvOKLFNO8BEhMcqqDVw==
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 7284897f-8e01-11ef-ac7d-25ccbfd3c7c9
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host217-43-3-134.range217-43.btcentralplus.com [217.43.3.134])
	by outbound3.eu.mailhop.org (Halon) with ESMTPA
	id 7284897f-8e01-11ef-ac7d-25ccbfd3c7c9;
	Sat, 19 Oct 2024 10:03:54 +0000 (UTC)
Received: from [10.57.1.52] (neptune.demonlair.co.uk [10.57.1.52])
	by phoenix.demonlair.co.uk (Postfix) with ESMTP id CB51D1EA10C;
	Sat, 19 Oct 2024 11:03:53 +0100 (BST)
Message-ID: <0e2df2b5-1215-44c3-b41a-086782c5fc37@demonlair.co.uk>
Date: Sat, 19 Oct 2024 11:03:53 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Cannot update homehost of an existing array: mdadm: /dev/sda3 has
 wrong name.
Content-Language: en-GB
To: Marc Haber <mh+linux-raid@zugschlus.de>, linux-raid@vger.kernel.org
References: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
From: Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <ZxNSmXIdVlQMWf9x@torres.zugschlus.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 19/10/2024 07:32, Marc Haber wrote:
> Hi,
>
> during a restore operation, I have recreated a RAID array using a rescue
> system. That new array ended up being named grml:0. Renaming the array
> to realhostname:md_root didn't work inside the rescue system
>
> The rescue system is reasonably current, using kernel 6.11.2 and mdadm
> 4.3.
>
> First, I tried changing the name of the array. That worked:
> # mdadm --assemble md_root --update=name --name=md_root /dev/sda3 /dev/sdb3
> mdadm: /dev/md/md_root has been started with 2 drives.
> # mdadm --examine /dev/sda3
> ... Name: grml:md_root  (local to host grml) ...
>
> What didn't work was changing the homehost:
> # mdadm --assemble md_root --update=homehost --name=realhostname /dev/sda3 /dev/sdb3
> mdadm: /dev/sda3 has wrong name.
> mdadm: /dev/sdb3 has wrong name.
I think instead of --name=realhostname you need --homehost=realhostname
here.
>
> Adding --force didn't work, same error message.
>
> What is the recommended way to create an array inside a rescue system
> that has homehost and name to the values the local admin wants, and/or
> to change those values for an array that has already been created and is
> filled with data?
>
> Greetings
> Marc
>

Geoff Back
What if we're all just characters in someone's nightmares?

