Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB9136D
	for <linux-raid@vger.kernel.org>; Mon,  2 Sep 2024 23:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725319882; cv=none; b=K6NgBSmnQqu28Q7CYx8M0FQjf9YxSHJ33DOs9BGT4RS6pCtMFWGNIHw6/28sjaNQLzSzgKW8GVpaSs9PHqjO/UHLrvcqwq02W/5AhV8TboQ0Bk4taPQ4DPmVk41k/DdPO8AjC5iQ0qS3MEHTktAzrwFu1cKlgoF2NgVsnNlZ3y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725319882; c=relaxed/simple;
	bh=0y/dpX8uC3d05LmIcEngDZs7RMcFRuZgZ4S2J1bCoDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PqFro4USSFrMXa+pHW6PEglTH7AT2dFszXWa6aDkAeh5MTHLdli4DylGz1Od/eq5y+E4MoON5wFCJu/0qwExZa6DwxkeovHCcRoEoa/5G2ThQk2eATmsr+tk4oDDAQx7f5IPSP7tslZOqQm/CgH2YRwVOgVpjgfiZBZuCIJrISQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpIgJm2m; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpIgJm2m"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-70f645a30dcso2721711a34.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 16:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725319880; x=1725924680; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:content-language:references:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6rUPW+FykJK1VkQ3h0heU5FHFbA9JPI13cj46uPuCVQ=;
        b=TpIgJm2mjoGU/Rfc18yKBPVYH7hvB3BkGZ38bDYps8SrqDLDj3hvv06vgIGjDkkPHF
         YLgSummxQQvTru2L5KPtkAFDuVusmGegOuH4vZIzh9ul/WO0Idu6xbQ/dEZX9ZoyHhxn
         5vULuW6n5IDCc9mFMD9uZYh68H/MJogpLCLMLBN0iMmXjHmt4uyjQ5sevnGHggxIKTQF
         xeP6TJRU17gwz1cKBU7EwUsd+Fq2ZR3NaMFftnCDM8KkHTjHHSAKEVaSEbceat1kV6Sd
         bIieYJ/Mm5+LWgJVbAah8wuUUGMe/UNBiGuyPbTU0m5Ys7BFPa2z2bYZDsI1js9SCcUv
         1eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725319880; x=1725924680;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:content-language:references:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rUPW+FykJK1VkQ3h0heU5FHFbA9JPI13cj46uPuCVQ=;
        b=DLSBwPTi1Gg7EX1wcw93iyEI++GkuA6xwUHQCwHxZDeUX8678uOYdngjPFgvjWbMCz
         OkgOEJ2wNyP3lKC/v3f6WM11bQ8EDiumKJgjf0GzmOtu0yt3Qew+auexdl1BQGKxr02f
         DmZuXRk5tf242MwT4dfS4JC/7wxg4R/8WyKlPeTl4pr7W+qrR9WdeFTkEZ5P5n82sdQf
         1M9zY7G92l2F6dKS+ihlmWVz9KjVjBzZy6Os112gZgz7h8dy8KihptubCY3xzs0oEPh7
         qtWJ+vQduG3VoTAaG+DlW4EbasWNKbiE5jAEPogvAeCSEPSlcEJh0xEMAoyFoVb6/fbF
         JPpw==
X-Gm-Message-State: AOJu0YxFPRSz8gIoxSJKCob/ykYWHmCwqnszDI2ORL0XZiC/HoUr7WgX
	ZDqU3iiM/rPxXLpaZPa9p7RFtlYIalPoVAZv9INF8c+S0CALBJi79OV1/g==
X-Google-Smtp-Source: AGHT+IEoIJ4SNwsfLhl2ALCSSVkss1au/JgcsezzhXwMtJ7OiF2Igf7VBKQeMyYzT9eYuFlOAM7XWA==
X-Received: by 2002:a05:6830:6110:b0:709:42dc:a024 with SMTP id 46e09a7af769-70f5c38f52fmr19809039a34.15.1725319879618;
        Mon, 02 Sep 2024 16:31:19 -0700 (PDT)
Received: from [192.168.6.104] (mail.3111skyline.com. [66.76.46.195])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-70f6715c9easm2179048a34.31.2024.09.02.16.31.18
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2024 16:31:19 -0700 (PDT)
Message-ID: <b34de424-9f7f-4057-a59f-c031939b4a6a@gmail.com>
Date: Mon, 2 Sep 2024 18:31:18 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: What RAID Level is this? (found on Refurb drive out of package)
To: mdraid <linux-raid@vger.kernel.org>
References: <e7956b07-f838-4282-b179-9883da259d9c@gmail.com>
 <ee66876c-c927-4387-b1a0-34d2db7212f6@gmail.com>
Content-Language: en-US
From: "David C. Rankin" <drankinatty@gmail.com>
In-Reply-To: <ee66876c-c927-4387-b1a0-34d2db7212f6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/2/24 8:15 AM, Paul E Luse wrote:
> 
> 
> It shows the RAID level above as 1E which is effectively RAID1 near layout as 
> described here: https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm
> 

Thank you for the link Paul,

   I've read it, but I'm still confused as to just what that raid was. Yes, I 
read that Raid1 2-disk can be the basis of a Raid 4, 5, 6 setup, but where I'm 
confused is the output shows:

    Secondary Level[1] : Striped
    Device Size[1] : 2925241344
     Array Size[1] : 46803861504

   Which shows the Array size as 46803861504 and Device Size as 2925241344. So 
the best I can glean from the wiki is that is some type of Raid0 setup made 
out of Raid1 mirrors.

   Where I also have trouble is with:

   Physical Disks : 255

   But earlier there was:

   Raid Devices[0] : 16 (15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@0K 22@0K 23@0K 
24@0K 25@0K 26@0K 27@0K 28@0K 29@0K 30@0K)

   I guess the 8-bit worth of physical disks that make up 16 raid devices (or 
16 physical disks per-device). I guess there is just no Cliff's Notes version 
that outlines all of the ways linux-raid can be fit together and extrapolated 
to make all kinds of things. Just glad I didn't have to work out the command 
line to replace a disk in that...

-- 
David C. Rankin, J.D.,P.E.

