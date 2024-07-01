Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A271350A80
	for <linux-raid@vger.kernel.org>; Mon,  1 Jul 2024 09:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719826408; cv=none; b=G6pNTOGtG0Xg8cKSxJpjxiQHabF8S4zo3vY8ZJUOqDBgf36KWEeLd5r2TFRdWBDSgTy/v7smzulGUtfP01HGqK2AfNYJV0ZHuRoAB5NbsK/u9cZUG44YXIgR5ahD2WHLNpX3a4Rzr8xxd2iIvKIAh30olhVWyu/C1NuHaer1aKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719826408; c=relaxed/simple;
	bh=P0aRyqCkwFKBTZnqT3U4AF/3KRdcmEkvSYnlS9wFZsE=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=LOS74QfnimaA72ZTxd7VIh9W8AxieArTCNNfOLc8ITlqZRz8p/xX5hqNHGqmcxNWdQSgrg6ma1V7G67sNzKwiqhcU8f0R40csGtNWQEpqA++zdlRCtgBYeVqIEF3ljf4AKY2rSMXayf3bB0Ps1+eNBeKXYy+mhUwH4yRlt6Cpo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=mNBJORuW; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="mNBJORuW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	 s=dkim; h=In-Reply-To:From:References:To:Subject:Reply-To:MIME-Version:Date:
	Message-ID:Content-Type:Sender:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WeFZO4Y9KH1YQxCfFzC+362UrzBimgtfJSXD9I6G+xY=; b=mNBJORuWzzSFf0kKbggWHV2fS5
	vXXCr+uMVjmM4RxaRN3y9twJz39bkVkSfIVaMpERKj2dNfeYaIHf4CvbzZwBS++CoH19wbgoxl2ev
	P7sqZmizbfApa8ZA+heY3+zA/oJbISAM70CFKI7HP0m6i1a3EFAtj40VOr/0PdiTJdjM=;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1sODPQ-000Gjw-LK; Mon, 01 Jul 2024 11:33:16 +0200
Content-Type: multipart/mixed; boundary="------------h6ZEcfh3UZtPbwaBXPUBSSpS"
Message-ID: <25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
Date: Mon, 1 Jul 2024 11:33:16 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: adam.niescierowicz@justnet.pl
Subject: Re: RAID6 12 device assemble force failure
To: linux-raid@vger.kernel.org
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
 <20240701105153.000066f3@linux.intel.com>
Content-Language: pl-PL
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <20240701105153.000066f3@linux.intel.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------h6ZEcfh3UZtPbwaBXPUBSSpS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

> On Sat, 29 Jun 2024 17:17:54 +0200
> Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:
>
>> Hi,
>>
>> i have raid 6 array on 12 disk attached via external SAS backplane
>> connected by 4 luns to the server. After some problems with backplane
>> when 3 disk went offline (in one second) and array stop.
>>
> And raid is considered as failed by mdadm and it is persistent with state of
> the devices in metadata.
>
>>      Device Role : spare
>>      Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' ==
>> replacing)
> 3 missing = failed raid 6 array.
>
>> I think the problem is that disk are recognised as spare, but why?
> Because mdadm cannot trust them because they are reported as "missing" so they
> are not configured as raid devices (spare is default state).
>> I tried with `mdadm --assemble --force --update=force-no-bbl
> It remove badblocks but not revert devices from "missing" to "active".
Is there a way to force state=active in the metadata?
 From what I saw each drive have exactly the same Events: 48640 and 
Update Time so data on the drive should be the same.
>> /dev/sd{q,p,o,n,m,z,y,z,w,t,s,r}1` and now mdam -E shows
>>
>>
>> ---
>>
>>             Magic : a92b4efc
>>           Version : 1.2
>>       Feature Map : 0x1
>>        Array UUID : f8fb0d5d:5cacae2e:12bf1656:18264fb5
>>              Name : backup:card1port1chassis2
>>     Creation Time : Tue Jun 18 20:07:19 2024
>>        Raid Level : raid6
>>      Raid Devices : 12
>>
>>    Avail Dev Size : 39063382016 sectors (18.19 TiB 20.00 TB)
>>        Array Size : 195316910080 KiB (181.90 TiB 200.00 TB)
>>       Data Offset : 264192 sectors
>>      Super Offset : 8 sectors
>>      Unused Space : before=264104 sectors, after=0 sectors
>>             State : clean
>>       Device UUID : e726c6bc:11415fcc:49e8e0a5:041b69e4
>>
>> Internal Bitmap : 8 sectors from superblock
>>       Update Time : Fri Jun 28 22:21:57 2024
>>          Checksum : 9ad1554c - correct
>>            Events : 48640
>>
>>            Layout : left-symmetric
>>        Chunk Size : 512K
>>
>>      Device Role : spare
>>      Array State : AAAAA.AA.A.A ('A' == active, '.' == missing, 'R' ==
>> replacing)
>> ---
>>
>>
>> What can I do to start this array?
>   You may try to add them manually. I know that there is
> --re-add functionality but I've never used it. Maybe something like that would
> work:
> #mdadm --remove /dev/md126 <failed drive>
> #mdadm --re-add /dev/md126 <failed_drive>
I tried this but didn't help.

-- 
---
Thanks
Adam Nieścierowicz

--------------h6ZEcfh3UZtPbwaBXPUBSSpS
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------h6ZEcfh3UZtPbwaBXPUBSSpS--
