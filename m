Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87991DA316
	for <linux-raid@vger.kernel.org>; Wed,  3 Jul 2024 21:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720041068; cv=none; b=X/C3CQRh/k6Nxt6dTMwP2jsAi2qXw/lqLyz/VbGp4ksOQI6oHZ5T4auN9iPICAJoF14ZoibS8Of0ZmxAj1RLyz/WLG16R8YEJL+6y6zDzt06J/A4YcOhXM+slXmsgWTHPbM3MXQy2URz8YSePyEecUhKOQZsDFC3zycOLIVzHuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720041068; c=relaxed/simple;
	bh=s7DTKJKmNPrtUWlFkMQA/xBUwmOyT/er77r30+S/HuQ=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=p0gFxFZ/E38B/P9m6uMKI2JPnVyzgeclIGY9hzZg+7q8YxJWTViC43tdn7nliOJbwpWFAjhjzAd693Ujh4zo7xx0t/eN8/C8KJI0eUpG0vCiubzOcbuhMpPROKLIPzsXjI+d4iEdjNRjkMKFbvG1k80gjE7j/Xx+McJy/tACIKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=LRg7XYhc; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="LRg7XYhc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	 s=dkim; h=In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:
	Date:Message-ID:Content-Type:Sender:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ntub0mmdylw7f4LwuAsGqD3u7/IhZNkKSgtRDo6SPjc=; b=LRg7XYhcndewe7qZ9f9VnEaWAI
	Jz1YMjXnk60kjKnU4bGyMEiLdCstevCZ3Vm+x5aOFFaDAYaBuwDyXclgTrdYwdH21q+Z6xFdL9vfO
	7FRdbwI9UOc12Az818J0Z0y4DdG+4iw/OGvlV0jAR9HtIvYP3EzLaymRd6New3mm8zu0=;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1sP7Fd-000iJm-3v; Wed, 03 Jul 2024 23:10:53 +0200
Content-Type: multipart/mixed; boundary="------------35MqsBB40YQTWPruPF9YZCoE"
Message-ID: <76d322e3-a18a-4ed7-9907-7ce77ec0842e@justnet.pl>
Date: Wed, 3 Jul 2024 23:10:52 +0200
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
Content-Language: pl-PL
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <20240703121610.00001041@linux.intel.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------35MqsBB40YQTWPruPF9YZCoE
Content-Type: multipart/alternative;
 boundary="------------vYtTuqODt3VAwPEIPgwrqZ0y"

--------------vYtTuqODt3VAwPEIPgwrqZ0y
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3.07.2024 o 12:16, Mariusz Tkaczyk wrote:
> On Wed, 3 Jul 2024 09:42:53 +0200
> Mariusz Tkaczyk<mariusz.tkaczyk@linux.intel.com>  wrote:
>
> I was able to achieve similar state:
>
> mdadm -E /dev/nvme2n1
> /dev/nvme2n1:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 8fd2cf1a:65a58b8d:0c9a9e2e:4684fb88
>             Name : gklab-localhost:my_r6  (local to host gklab-localhost)
>    Creation Time : Wed Jul  3 09:43:32 2024
>       Raid Level : raid6
>     Raid Devices : 4
>
>   Avail Dev Size : 1953260976 sectors (931.39 GiB 1000.07 GB)
>       Array Size : 10485760 KiB (10.00 GiB 10.74 GB)
>    Used Dev Size : 10485760 sectors (5.00 GiB 5.37 GB)
>      Data Offset : 264192 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=264112 sectors, after=1942775216 sectors
>            State : clean
>      Device UUID : b26bef3c:51813f3f:e0f1a194:c96c4367
>
>      Update Time : Wed Jul  3 11:49:34 2024
>    Bad Block Log : 512 entries available at offset 16 sectors
>         Checksum : a96eaa64 - correct
>           Events : 6
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>     Device Role : Active device 2
>     Array State : ..A. ('A' == active, '.' == missing, 'R' == replacing)
>
>
> In my case, events value was different and /dev/nvme3n1 had different Array
> State:
>   Device Role : Active device 3
>     Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)

This kind of array behavior is like it should be?

Why I'm asking, in theory.

We have bitmap so when third drive disconnect from the array we should 
have time to stop the array in foulty state before bitmap space is over, 
yes?.
Next array send notification to FS(filesystem) that there is a problem 
and will discard all write operation.

Data that can't be store on the foulty device should be keep in the bitmap.
Next when we reatach missing third drive when we write missing data from 
bitmap to disk everything should be good, yes?

I'm thinking correctly?


> And I failed to start it, sorry. It is possible but it requires to work with
> sysfs and ioctls directly so much safer is to recreate an array with
> --assume-clean, especially that it is fresh array.

I recreated the array, LVM detected PV and works fine but XFS above the 
LVM is missing data from recreate array.

-- 
---
Pozdrawiam
Adam Nieścierowicz

--------------vYtTuqODt3VAwPEIPgwrqZ0y
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <div class="moz-cite-prefix">On 3.07.2024 o 12:16, Mariusz Tkaczyk
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20240703121610.00001041@linux.intel.com">
      <pre class="moz-quote-pre" wrap="">On Wed, 3 Jul 2024 09:42:53 +0200
Mariusz Tkaczyk <a class="moz-txt-link-rfc2396E" href="mailto:mariusz.tkaczyk@linux.intel.com">&lt;mariusz.tkaczyk@linux.intel.com&gt;</a> wrote:

I was able to achieve similar state:

mdadm -E /dev/nvme2n1
/dev/nvme2n1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 8fd2cf1a:65a58b8d:0c9a9e2e:4684fb88
           Name : gklab-localhost:my_r6  (local to host gklab-localhost)
  Creation Time : Wed Jul  3 09:43:32 2024
     Raid Level : raid6
   Raid Devices : 4

 Avail Dev Size : 1953260976 sectors (931.39 GiB 1000.07 GB)
     Array Size : 10485760 KiB (10.00 GiB 10.74 GB)
  Used Dev Size : 10485760 sectors (5.00 GiB 5.37 GB)
    Data Offset : 264192 sectors
   Super Offset : 8 sectors
   Unused Space : before=264112 sectors, after=1942775216 sectors
          State : clean
    Device UUID : b26bef3c:51813f3f:e0f1a194:c96c4367

    Update Time : Wed Jul  3 11:49:34 2024
  Bad Block Log : 512 entries available at offset 16 sectors
       Checksum : a96eaa64 - correct
         Events : 6

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : ..A. ('A' == active, '.' == missing, 'R' == replacing)


In my case, events value was different and /dev/nvme3n1 had different Array
State:
 Device Role : Active device 3
   Array State : ..AA ('A' == active, '.' == missing, 'R' == replacing)
</pre>
    </blockquote>
    <p>This kind of array behavior is like it should be? <br>
    </p>
    <p>Why I'm asking, in theory.</p>
    <p>We have bitmap so when third drive disconnect from the array we
      should have time to stop the array in foulty state before bitmap
      space is over, yes?. <br>
      Next array send notification to FS(filesystem) that there is a
      problem and will discard all write operation.<br>
      <br>
      Data that can't be store on the foulty device should be keep in
      the bitmap. <br>
      Next when we reatach missing third drive when we write missing
      data from bitmap to disk everything should be good, yes?<br>
      <br>
      I'm thinking correctly?</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:20240703121610.00001041@linux.intel.com">
      <pre class="moz-quote-pre" wrap="">
And I failed to start it, sorry. It is possible but it requires to work with
sysfs and ioctls directly so much safer is to recreate an array with
--assume-clean, especially that it is fresh array.
</pre>
    </blockquote>
    <p>I recreated the array, LVM detected PV and works fine but XFS
      above the LVM is missing data from recreate array.</p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <pre class="moz-signature" cols="72">-- 
---
Pozdrawiam
Adam Nieścierowicz</pre>
  </body>
</html>

--------------vYtTuqODt3VAwPEIPgwrqZ0y--
--------------35MqsBB40YQTWPruPF9YZCoE
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------35MqsBB40YQTWPruPF9YZCoE--
