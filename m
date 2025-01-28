Received: from ida.uls.co.za (ida.uls.co.za [154.73.32.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38261161310
	for <linux-raid@vger.kernel.org>; Tue, 28 Jan 2025 21:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=154.73.32.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738101390; cv=none; b=gzcf6yFBYtSrvzMUKARxhYAaPyAMYCpMnJ3rb/n4QWDzXlqFYkoQ7IqkNN+mG+S4FvZyPJhG2DSRXM8j6L9YFdTI0rAphr7siC3QX9CnYD6zPcEYPcbxmL55cu7nLANTzEpSGZwDxl8XGoSXtBf75z3+6O8bgPLfWAEjYS/SxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738101390; c=relaxed/simple;
	bh=wJ7s6mECUErh0qXOj2ZHsiXBjnQDP8+xyaosAzvmcbg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=h/ngE9Bgp4ddpXiyYYg09M76E/O4qNwichuOHXhuRMjBraoeQVrFxgU7oNMBTs0csz04joF9BGli+NCNdXzzsHYoM+XlMIsg7wIDmMzYzVRTL+/4l3yNxooy/6lyCHnVKKqImmARxQOOMTXVLrbjII25wvEHPh/PDRPsmGpQqLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uls.co.za; spf=pass smtp.mailfrom=uls.co.za; arc=none smtp.client-ip=154.73.32.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uls.co.za
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uls.co.za
Received: from [192.168.241.147]
	by ida.uls.co.za with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.97.1)
	(envelope-from <jaco@uls.co.za>)
	id 1tct7c-000000004Dg-0vxx
	for linux-raid@vger.kernel.org;
	Tue, 28 Jan 2025 23:27:49 +0200
Message-ID: <d12d05b8-b33d-49df-b8d1-352a12bc082c@uls.co.za>
Date: Tue, 28 Jan 2025 23:27:45 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB
To: linux-raid@vger.kernel.org
From: Jaco Kroon <jaco@uls.co.za>
Subject: Altering the meta data version of md raid
Autocrypt: addr=jaco@uls.co.za; keydata=
 xsBNBFXtplYBCADM6RTLCOSPiclevkn/gdf8h9l+kKA6N+WGIIFuUtoc9Gaf8QhXWW/fvUq2
 a3eo4ULVFT1jJ56Vfm4MssGA97NZtlOe3cg8QJMZZhsoN5wetG9SrJvT9Rlltwo5nFmXY3ZY
 gXsdwkpDr9Y5TqBizx7DGxMd/mrOfXeql57FWFeOc2GuJBnHPZQMJsQ66l2obPn36hWEtHYN
 gcUSPH3OOusSEGZg/oX/8WSDQ/b8xz1JKTEgcnu/JR0FxzjY19zSHmbnyVU+/gF3oeJFcEUk
 HvZu776LRVdcZ0lb1bHQB2K9rTZBVeZLitgAefPVH2uERVSO8EZO1I5M7afV0Kd/Vyn9ABEB
 AAHNG0phY28gS3Jvb24gPGphY29AdWxzLmNvLnphPsLAdwQTAQgAIQUCVe2mVgIbAwULCQgH
 AgYVCAkKCwIEFgIDAQIeAQIXgAAKCRAILcSxr/fungCPB/sHrfufpRbrVTtHUjpbY4bTQLQE
 bVrh4/yMiKprALRYy0nsMivl16Q/3rNWXJuQ0gR/faC3yNlDgtEoXx8noXOhva9GGHPGTaPT
 hhpcp/1E4C9Ghcaxw3MRapVnSKnSYL+zOOpkGwye2+fbqwCkCYCM7Vu6ws3+pMzJNFK/UOgW
 Tj8O5eBa3DiU4U26/jUHEIg74U+ypYPcj5qXG0xNXmmoDpZweW41Cfo6FMmgjQBTEGzo9e5R
 kjc7MH3+IyJvP4bzE5Paq0q0b5zZ8DUJFtT7pVb3FQTz1v3CutLlF1elFZzd9sZrg+mLA5PM
 o8PG9FLw9ZtTE314vgMWJ+TTYX0kzsBNBFXtplYBCADedX9HSSJozh4YIBT+PuLWCTJRLTLu
 jXU7HobdK1EljPAi1ahCUXJR+NHvpJLSq/N5rtL12ejJJ4EMMp2UUK0IHz4kx26FeAJuOQMe
 GEzoEkiiR15ufkApBCRssIj5B8OA/351Y9PFore5KJzQf1psrCnMSZoJ89KLfU7C5S+ooX9e
 re2aWgu5jqKgKDLa07/UVHyxDTtQKRZSFibFCHbMELYKDr3tUdUfCDqVjipCzHmLZ+xMisfn
 yX9aTVI3FUIs8UiqM5xlxqfuCnDrKBJjQs3uvmd6cyhPRmnsjase48RoO84Ckjbp/HVu0+1+
 6vgiPjbe4xk7Ehkw1mfSxb79ABEBAAHCwF8EGAEIAAkFAlXtplYCGwwACgkQCC3Esa/37p7u
 XwgAjpFzUj+GMmo8ZeYwHH6YfNZQV+hfesr7tqlZn5DhQXJgT2NF6qh5Vn8TcFPR4JZiVIkF
 o0je7c8FJe34Aqex/H9R8LxvhENX/YOtq5+PqZj59y9G9+0FFZ1CyguTDC845zuJnnR5A0lw
 FARZaL8T7e6UGphtiT0NdR7EXnJ/alvtsnsNudtvFnKtigYvtw2wthW6CLvwrFjsuiXPjVUX
 825zQUnBHnrED6vG67UG4z5cQ4uY/LcSNsqBsoj6/wsT0pnqdibhCWmgFimOsSRgaF7qsVtg
 TWyQDTjH643+qYbJJdH91LASRLrenRCgpCXgzNWAMX6PJlqLrNX1Ye4CQw==
Organization: Ultimate Linux Solutions (Pty) Ltd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-report: Relay access (ida.uls.co.za).

Hi All,

The question is simple, if an historic array has been created with 0.90 
metadata version, is it possible to upgrade that to 1.x, and if so, how?

https://serverfault.com/questions/142318/can-you-change-the-metadata-version-on-an-existing-array

Is the best reference I could find and boils down to "no" but it's not a 
definitive.

The disks in the specific array (12 disks, RAID6) has been upgraded by 
way of rebuild one by one from 4TB to 10TB, but with the 0.90 metadata 
only ~4.4TB of each drive can be utilized.

I can *potentially* work around this by adding four of the 4TB drives 
back, creating a new temporary array with the correct format, then using 
pvmove to repeatedly clear data out of the upper end of the historic 
raid, shrinking the array by a drive, adding same to the replacement 
array.  I just need to make sure I'm going to be able to get the last 
bit of data migrated (sizing thing).

For obvious reasons an upgrade of the metadata will be simpler, if 
possible.  No sensible backup option here ... unless I can find around 
80TB of storage for full system backup (there are currently three arrays 
in the system, one other array will run into the same problem 
eventually).  But now that I'm aware of the problem we can re-emptively 
make a plan to avoid the problem for that case.

Kind regards,
Jaco


