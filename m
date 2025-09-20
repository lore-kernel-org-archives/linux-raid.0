Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068EB1FE471;
	Sat, 20 Sep 2025 10:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758362680; cv=pass; b=dMKs5ogf1ZjjxbK2prLIZSXaXpn0fpd/UOxv7fTOA8aQMmgNtcjEklOPxT/3vXYjdipMzhWm0UwYmEzYtPyVm+pNZMt69DRGaZzYxKkzAdjuKayaBYqur8bMtmY0pVKKkMIdln5Ajuzbl35V3mT8JThFwCcfhXAo9KgOm65G5QU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758362680; c=relaxed/simple;
	bh=DVuDMeUkFM91/7S1N28fNZvOt8tT9a8bTnz4V9jbnDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSkHByLgZY7Vd1E/evaKX3XZkZhphNmtdIfMq/jgKjlsHi5rWzWUMaw5O/uhJUqiir7VmfvrDvF4FhCNixIVGysArpn5ltlOqivMzVNZNdiYmrR0WZsKtueccQOeSfeij6uekpbFVJKLGA4pEjMo3Xtf4OqvucvizAHtoNGMyeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=VAoCn2Hj; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="VAoCn2Hj"
ARC-Seal: i=1; a=rsa-sha256; t=1758362660; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BnQcmQ30p3f85UJedjH+2FrynM2toDEDldM69pnD+aBd5GVFTAx+GPzn80iwMY5N9aIsGFM7pX4hv8g5Lf65D4r4uDl4GJXoq6F7kPXvORcnb90sYgfI9whLf7hLpmYGritb22qyM8CEWwk8MMBSzDT7QfRyisgjqGklOe5DoWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758362660; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=scMBsq9OJ2+85ITVv5uYxeQFUskD5/jOHmUAM+DzTIY=; 
	b=TeSdEkz7pkA1pD9Ax8HX06pcIZYRDrvxbxgsmceQEB3Er+tPl3oG/73BxL4OO2FLJAiauTbnap5qPbFDUNsg7ykXONS5bBsX0/vBcmxh4xOT6uggYDOKnIoMNdzVdGsq7REASbtr7qKV2HWoj26PbqKSpI7tLXZtWfHVIWfixMk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758362660;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=scMBsq9OJ2+85ITVv5uYxeQFUskD5/jOHmUAM+DzTIY=;
	b=VAoCn2Hj26fQA6XPzzZuYaE7yBqJj4sMTFtp8v6VBOaNuHEJa+I3i32QbRsFzFtP
	q3gLyQvX4iyU2ZSYYOL2qGau6uxzMEGo/En73+nck1Eq4AIh6ohCh8VJSno3uIShZBL
	lMxB8wfYPQg57R0w9syWfwxYE9VJKGsxcJM+BpBU=
Received: by mx.zohomail.com with SMTPS id 1758362658925615.9865317087117;
	Sat, 20 Sep 2025 03:04:18 -0700 (PDT)
Message-ID: <64cc0632-37dd-4070-9158-3dab69e1ad27@yukuai.org.cn>
Date: Sat, 20 Sep 2025 18:04:14 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-llbitmap: Remove unneeded semicolon
To: Chen Ni <nichen@iscas.ac.cn>, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250910091912.25624-1-nichen@iscas.ac.cn>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20250910091912.25624-1-nichen@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

在 2025/9/10 17:19, Chen Ni 写道:

> Remove unnecessary semicolons reported by Coccinelle/coccicheck and the
> semantic patch at scripts/coccinelle/misc/semicolon.cocci.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
>   drivers/md/md-llbitmap.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 3337d5c7e7e5..0f15428b2403 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -378,7 +378,7 @@ static void llbitmap_infect_dirty_bits(struct llbitmap *llbitmap,
>   		case BitClean:
>   			pctl->state[pos] = BitDirty;
>   			break;
> -		};
> +		}
>   	}
>   }
>   

Applied to md-6.18

Thanks
Kuai

