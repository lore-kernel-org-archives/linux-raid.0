Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B781E494
	for <linux-raid@vger.kernel.org>; Thu,  4 Jul 2024 12:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720096534; cv=none; b=NBWL0R8Gs7IeQS8OHMCt5c5irixs5denQ0w1sAFuUyai3YbD59oL+j5EuAZXWOHvh0IdOhHlRglWahwnn9Yl/ClRSdgOWWyaM2xLqxXh6EBPhYtkSuXCQhk0/7LwKHAoh8LvQh2QjQM8a8WCAqw4nDKYIq5LfccLZ8H5umBKLz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720096534; c=relaxed/simple;
	bh=YF96IKGdmHOH/QNT1F+IbK8E3XagQvaqUhosfaNsxx4=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=WVAR7g8vqefpVdxT2T+wlVkCcjRxmPxZY1Q+ACRRizWlku5pxP2Ybq3aRswTb0Ffti/5Epf0Fd4uzk6o0PiZ5OKpvvF1CzzECzxHi3UrLHp5Mlxanlvr3sZoyiPiO/YAMwuxpj0VJuSfSPo+vzetU5qtpVNXforT4OyArHhbw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=siEuEm8F; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="siEuEm8F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	 s=dkim; h=In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:
	Date:Message-ID:Content-Type:Sender:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=n59IjRD766SI+k4FcO/Zyk9Rzzfv0QhWUmc/8Ns62tk=; b=siEuEm8F1ayiaqQskdZQmtb6g2
	jd4C4WHR9KetjRZ1ZyURJyr+3UYtxjJe1OdGS4d7TO3KZ4e+6mQJTRzO0Y09hJ5ylG6z0Um66gg/Y
	ZwXVVN2GdqkyXSFRYMcZp+9wvEOFCGv5tg6jMzKhhyszo27hX1b4WzPIqpjYZVKUsTn4=;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1sPLgN-000p13-3X; Thu, 04 Jul 2024 14:35:27 +0200
Content-Type: multipart/mixed; boundary="------------CjPa5UT8bRL52f0nRfo3hc8B"
Message-ID: <9d4c77f9-9c08-48f1-8e0b-03adc90eec89@justnet.pl>
Date: Thu, 4 Jul 2024 14:35:26 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: adam.niescierowicz@justnet.pl
Subject: Re: RAID6 12 device assemble force failure
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
 <20240701105153.000066f3@linux.intel.com>
 <25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
 <20240702104715.00007a35@linux.intel.com>
 <347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
 <20240703094253.00007a94@linux.intel.com>
 <20240703121610.00001041@linux.intel.com>
 <76d322e3-a18a-4ed7-9907-7ce77ec0842e@justnet.pl>
 <20240704130610.00007f6a@linux.intel.com>
Content-Language: pl-PL
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <20240704130610.00007f6a@linux.intel.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------CjPa5UT8bRL52f0nRfo3hc8B
Content-Type: multipart/alternative;
 boundary="------------IjyYk2eQQe7ahFeqSXzbTIcU"

--------------IjyYk2eQQe7ahFeqSXzbTIcU
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4.07.2024 o 13:06, Mariusz Tkaczyk wrote:
>> Data that can't be store on the foulty device should be keep in the bitmap.
>> Next when we reatach missing third drive when we write missing data from
>> bitmap to disk everything should be good, yes?
>>
>> I'm thinking correctly?
>>
> Bitmap doesn't record writes. Please read:
> https://man7.org/linux/man-pages/man4/md.4.html
> bitmap is used to optimize resync and recovery in case of re-add (but we
> know that it won't work in your case).

Is there a way to make storage more fault tolerant?

 From what I saw till now one array=one PV(LVM)=LV(LVM)=one FS.

Mixing two array in LVM and FS isn't good practice.


But what about raid configuration?
I have 4 external backplane, 12 disk each. Each backplane is attached by 
external four SAS LUNs.
In scenario where I attache three disk to one LUN and one LUN crash or 
hang and next restart or ... data on the array will be damaged, yes?

I think that I can create raid5 array for three disk in one LUN so when 
LUN freeze, disconect, hungs or etc one array will stop like server 
crash without power and this should be recovable(until now I didn't have 
problem with array rebuild in this kind of situation)

Problem is with disk usage, each 12 pcs backplane will use 4 disk for 
parity( 12 disk=4 luns = 4 raid 5 array).

Is there better way to do this?


> And I failed to start it, sorry. It is possible but it requires to 
> work with
>>> sysfs and ioctls directly so much safer is to recreate an array with
>>> --assume-clean, especially that it is fresh array.
>> I recreated the array, LVM detected PV and works fine but XFS above the
>> LVM is missing data from recreate array.
>>
> Well, it looks like you did it right because LVM is up. Please compare if disks
> are ordered same way in new array (indexes of the drives in mdadm -D output).
> Just do be double sure.

How can I assigne raid disk number to each disk?


-- 
---
Pozdrawiam
Adam Nieścierowicz

--------------IjyYk2eQQe7ahFeqSXzbTIcU
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 4.07.2024 o 13:06, Mariusz Tkaczyk
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20240704130610.00007f6a@linux.intel.com"><span
      style="white-space: pre-wrap">
</span>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Data that can't be store on the foulty device should be keep in the bitmap.
Next when we reatach missing third drive when we write missing data from 
bitmap to disk everything should be good, yes?

I'm thinking correctly?

</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Bitmap doesn't record writes. Please read:
<a class="moz-txt-link-freetext" href="https://man7.org/linux/man-pages/man4/md.4.html">https://man7.org/linux/man-pages/man4/md.4.html</a>
bitmap is used to optimize resync and recovery in case of re-add (but we
know that it won't work in your case). 
</pre>
    </blockquote>
    <p>Is there a way to make storage more fault tolerant? </p>
    <p>From what I saw till now one array=one PV(LVM)=LV(LVM)=one FS.</p>
    <p>Mixing two array in LVM and FS isn't good practice.<br>
    </p>
    <p><br>
    </p>
    <p>But what about raid configuration?<br>
      I have 4 external backplane, 12 disk each. Each backplane is
      attached by external four SAS LUNs. <br>
      In scenario where I attache three disk to one LUN and one LUN
      crash or hang and next restart or ... data on the array will be
      damaged, yes?<br>
    </p>
    <p>I think that I can create raid5 array for three disk in one LUN
      so when LUN freeze, disconect, hungs or etc one array will stop
      like server crash without power and this should be recovable(until
      now I didn't have problem with array rebuild in this kind of
      situation)<br>
    </p>
    <p>Problem is with disk usage, each 12 pcs backplane will use 4 disk
      for parity( 12 disk=4 luns = 4 raid 5 array).<br>
    </p>
    <p>Is there better way to do this?<br>
    </p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20240704130610.00007f6a@linux.intel.com"><span
      style="white-space: pre-wrap">And I failed to start it, sorry. It is possible but it requires to work with</span>
      <blockquote type="cite">
        <blockquote type="cite">
          <pre class="moz-quote-pre" wrap="">sysfs and ioctls directly so much safer is to recreate an array with
--assume-clean, especially that it is fresh array.  
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">
I recreated the array, LVM detected PV and works fine but XFS above the 
LVM is missing data from recreate array.

</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Well, it looks like you did it right because LVM is up. Please compare if disks
are ordered same way in new array (indexes of the drives in mdadm -D output).
Just do be double sure.
</pre>
    </blockquote>
    <p>How can I assigne raid disk number to each disk?<br>
    </p>
    <p><br>
    </p>
    <span style="white-space: pre-wrap">
</span>
    <pre class="moz-signature" cols="72">-- 
---
Pozdrawiam
Adam Nieścierowicz</pre>
  </body>
</html>

--------------IjyYk2eQQe7ahFeqSXzbTIcU--
--------------CjPa5UT8bRL52f0nRfo3hc8B
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------CjPa5UT8bRL52f0nRfo3hc8B--
