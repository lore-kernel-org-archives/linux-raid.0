Received: from mail.justnet.pl (mail.justnet.pl [78.9.185.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA8243152
	for <linux-raid@vger.kernel.org>; Tue,  2 Jul 2024 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=78.9.185.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719942485; cv=none; b=mVZ4b6xZ6TmBqPsMcd20opdGSWnJHF3owFYdbwEWTYj0ppyYnOMuFaZeWpWOzRGujYCF/JiZ6l2KeL5PBqdMNz+Xe4AxgBnVlyz7W1qCeKBdEskN/Tu4+hEBPctULlRpGODkZSC3Obnf5ILewsOwAJchXZy65yDvi4rGXFk9O7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719942485; c=relaxed/simple;
	bh=CHZZLpumnrxe5KmvAY3Dyn3rYW18y7jjoiBZA/8Otzc=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=NUnBCnep3Ocqe02eniYYb/yPrx3b06VJUVTKIANp8SgbnxHzV8TXerKro/dbZhThoOEBJeL+esl1++CP4+0jNxfAuLmKga/61/aoSMfn3UrpNEaCQNRqZTP5ijk4YTeCIY3RyB0lZ4pUM0Nkjf7tKO5aWhIyVQi+q+nu2dWSiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl; spf=pass smtp.mailfrom=justnet.pl; dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b=f5W/L9X3; arc=none smtp.client-ip=78.9.185.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=justnet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justnet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=justnet.pl header.i=@justnet.pl header.b="f5W/L9X3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=justnet.pl;
	 s=dkim; h=In-Reply-To:From:References:Cc:To:Subject:Reply-To:MIME-Version:
	Date:Message-ID:Content-Type:Sender:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=P/KviKCSAM7jXWeHATGejBCEg3AIBCmsQX0ja9JDQxM=; b=f5W/L9X3wvrTfxnOxT7ScJSASW
	DMPHFqx4fXCdFO/72YPVnGquMNtF9OYesKpf6R+EQXzTmNjL1u2lXxRnmcUMTP1bUjheigByPHiMT
	iXWmpLoxK+xpUAtawaRXh6aa0BYGd09Bpd7GSCxdWbz7BjuEZKgQwzylb3hYIlsyR9So=;
Received: from [78.9.185.84] (helo=[192.168.255.66])
	by mail.justnet.pl with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.92)
	(envelope-from <adam.niescierowicz@justnet.pl>)
	id 1sOhbd-000Vgo-99; Tue, 02 Jul 2024 19:47:53 +0200
Content-Type: multipart/mixed; boundary="------------x5UAEdID4ZkgJRK4pYXuQxG6"
Message-ID: <347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
Date: Tue, 2 Jul 2024 19:47:52 +0200
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
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
 <20240701105153.000066f3@linux.intel.com>
 <25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
 <20240702104715.00007a35@linux.intel.com>
Content-Language: pl-PL
From: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Organization: =?UTF-8?Q?Adam_Nie=C5=9Bcierowicz_JustNet?=
In-Reply-To: <20240702104715.00007a35@linux.intel.com>
X-Spam-Score: -1.0
X-Spam-Level: -

This is a multi-part message in MIME format.
--------------x5UAEdID4ZkgJRK4pYXuQxG6
Content-Type: multipart/alternative;
 boundary="------------Nu8N7iHFfx9LLx3AQLIo502T"

--------------Nu8N7iHFfx9LLx3AQLIo502T
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 2.07.2024 o 10:47, Mariusz Tkaczyk wrote:
> On Mon, 1 Jul 2024 11:33:16 +0200
> Adam Niescierowicz<adam.niescierowicz@justnet.pl>  wrote:
>
>> Is there a way to force state=active in the metadata?
>>   From what I saw each drive have exactly the same Events: 48640 and
>> Update Time so data on the drive should be the same.
> The most important: I advice you to clone disks to have a safe space for
> practicing. Whatever you will do is risky now, we don't want to make
> situation worse. My suggestions might be destructible and I don't want to take
> responsibility of making it worse.
I am aware of the danger. Thank you also for your help.
> We have --dump and --restore functionality, I've never used it
> (I mainly IMSM focused) so I can just point you that it is there and it is an
> option to clone metadata.
>
> native metadata keep both spares and data in the same array, and we can see
> that spare states for those 3 devices are consistently reported on every drive.
>
> It means that at some point metadata with missing disk states updated to
> spares  has been written to the all array members (including spares) but it does
> not mean that the data is consistent. You are recovering from error scenario and
> whatever is there, you need to be read for the worst case.
>
> The brute-force method would be to recreate an array with same startup
> parameters and --assume-clean flag but this is risky. Probably your array
> was initially created few years (and mdadm versions) so there could be small
> differences in the array parameters mdadm sets now. Anyway, I see it as the
> simplest option.

In my situation this is fresh config like 2 weeks and I can install 
exactly the same mdadm version.

If there will be no other way to process I will try to create array 
--force --assume-clean

> We can try to start array manually by setting sysfs values, however it will
> require well familiarize with mdadm code so would be time consuming.
>
>>>> What can I do to start this array?
>>>    You may try to add them manually. I know that there is
>>> --re-add functionality but I've never used it. Maybe something like that
>>> would
>>> work:
>>> #mdadm --remove /dev/md126 <failed drive>
>>> #mdadm --re-add /dev/md126 <failed_drive>
>> I tried this but didn't help.
> Please provide a logs then (possibly with -vvvvv) maybe I or someone else would
> help.

Logs
---

# mdadm --run -vvvvv /dev/md126
mdadm: failed to start array /dev/md/card1pport2chassis1: Input/output error

# mdadm --stop /dev/md126
mdadm: stopped /dev/md126

# mdadm --assemble --force -vvvvv /dev/md126 /dev/sdq1 /dev/sdv1 
/dev/sdr1 /dev/sdu1 /dev/sdz1 /dev/sdx1 /dev/sdk1 /dev/sds1 /dev/sdm1 
/dev/sdn1 /dev/sdw1 /dev/sdt1
mdadm: looking for devices for /dev/md126
mdadm: /dev/sdq1 is identified as a member of /dev/md126, slot -1.
mdadm: /dev/sdv1 is identified as a member of /dev/md126, slot 1.
mdadm: /dev/sdr1 is identified as a member of /dev/md126, slot 6.
mdadm: /dev/sdu1 is identified as a member of /dev/md126, slot -1.
mdadm: /dev/sdz1 is identified as a member of /dev/md126, slot 11.
mdadm: /dev/sdx1 is identified as a member of /dev/md126, slot 9.
mdadm: /dev/sdk1 is identified as a member of /dev/md126, slot -1.
mdadm: /dev/sds1 is identified as a member of /dev/md126, slot 7.
mdadm: /dev/sdm1 is identified as a member of /dev/md126, slot 3.
mdadm: /dev/sdn1 is identified as a member of /dev/md126, slot 2.
mdadm: /dev/sdw1 is identified as a member of /dev/md126, slot 4.
mdadm: /dev/sdt1 is identified as a member of /dev/md126, slot 0.
mdadm: added /dev/sdv1 to /dev/md126 as 1
mdadm: added /dev/sdn1 to /dev/md126 as 2
mdadm: added /dev/sdm1 to /dev/md126 as 3
mdadm: added /dev/sdw1 to /dev/md126 as 4
mdadm: no uptodate device for slot 5 of /dev/md126
mdadm: added /dev/sdr1 to /dev/md126 as 6
mdadm: added /dev/sds1 to /dev/md126 as 7
mdadm: no uptodate device for slot 8 of /dev/md126
mdadm: added /dev/sdx1 to /dev/md126 as 9
mdadm: no uptodate device for slot 10 of /dev/md126
mdadm: added /dev/sdz1 to /dev/md126 as 11
mdadm: added /dev/sdq1 to /dev/md126 as -1
mdadm: added /dev/sdu1 to /dev/md126 as -1
mdadm: added /dev/sdk1 to /dev/md126 as -1
mdadm: added /dev/sdt1 to /dev/md126 as 0
mdadm: /dev/md126 assembled from 9 drives and 3 spares - not enough to 
start the array.
---

Can somebody explain me behavior of the array? (theory)

This is RAID-6 so after two disk are disconnected it still works fine. 
Next when third disk disconnect the array should stop as faulty, yes?
If array stop as faulty the data on array and third disconnected disk 
should be the same, yes?


-- 
---
Thanks
Adam Nieścierowicz

--------------Nu8N7iHFfx9LLx3AQLIo502T
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 2.07.2024 o 10:47, Mariusz Tkaczyk
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:20240702104715.00007a35@linux.intel.com">
      <pre class="moz-quote-pre" wrap="">On Mon, 1 Jul 2024 11:33:16 +0200
Adam Niescierowicz <a class="moz-txt-link-rfc2396E" href="mailto:adam.niescierowicz@justnet.pl">&lt;adam.niescierowicz@justnet.pl&gt;</a> wrote:

</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">Is there a way to force state=active in the metadata?
 From what I saw each drive have exactly the same Events: 48640 and 
Update Time so data on the drive should be the same.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
The most important: I advice you to clone disks to have a safe space for
practicing. Whatever you will do is risky now, we don't want to make
situation worse. My suggestions might be destructible and I don't want to take
responsibility of making it worse.</pre>
    </blockquote>
    I am aware of the danger. Thank you also for your help.<br>
    <blockquote type="cite"
      cite="mid:20240702104715.00007a35@linux.intel.com">
      <pre class="moz-quote-pre" wrap="">
We have --dump and --restore functionality, I've never used it
(I mainly IMSM focused) so I can just point you that it is there and it is an
option to clone metadata.

native metadata keep both spares and data in the same array, and we can see
that spare states for those 3 devices are consistently reported on every drive.

It means that at some point metadata with missing disk states updated to
spares  has been written to the all array members (including spares) but it does
not mean that the data is consistent. You are recovering from error scenario and
whatever is there, you need to be read for the worst case.

The brute-force method would be to recreate an array with same startup
parameters and --assume-clean flag but this is risky. Probably your array
was initially created few years (and mdadm versions) so there could be small
differences in the array parameters mdadm sets now. Anyway, I see it as the
simplest option.
</pre>
    </blockquote>
    <p>In my situation this is fresh config like 2 weeks and I can
      install exactly the same mdadm version.</p>
    <p>If there will be no other way to process I will try to create
      array --force --assume-clean<br>
    </p>
    <blockquote type="cite"
      cite="mid:20240702104715.00007a35@linux.intel.com">
      <pre class="moz-quote-pre" wrap="">
We can try to start array manually by setting sysfs values, however it will
require well familiarize with mdadm code so would be time consuming.

</pre>
      <blockquote type="cite">
        <blockquote type="cite">
          <blockquote type="cite">
            <pre class="moz-quote-pre" wrap="">What can I do to start this array?  
</pre>
          </blockquote>
          <pre class="moz-quote-pre" wrap="">  You may try to add them manually. I know that there is
--re-add functionality but I've never used it. Maybe something like that
would
work:
#mdadm --remove /dev/md126 &lt;failed drive&gt;
#mdadm --re-add /dev/md126 &lt;failed_drive&gt;  
</pre>
        </blockquote>
        <pre class="moz-quote-pre" wrap="">I tried this but didn't help.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Please provide a logs then (possibly with -vvvvv) maybe I or someone else would
help.
</pre>
    </blockquote>
    <p>Logs<br>
      ---</p>
    <p># mdadm --run -vvvvv /dev/md126<br>
      mdadm: failed to start array /dev/md/card1pport2chassis1:
      Input/output error<br>
    </p>
    <p># mdadm --stop /dev/md126<br>
      mdadm: stopped /dev/md126</p>
    <p># mdadm --assemble --force -vvvvv /dev/md126 /dev/sdq1 /dev/sdv1
      /dev/sdr1 /dev/sdu1 /dev/sdz1 /dev/sdx1 /dev/sdk1 /dev/sds1
      /dev/sdm1 /dev/sdn1 /dev/sdw1 /dev/sdt1<br>
      mdadm: looking for devices for /dev/md126<br>
      mdadm: /dev/sdq1 is identified as a member of /dev/md126, slot -1.<br>
      mdadm: /dev/sdv1 is identified as a member of /dev/md126, slot 1.<br>
      mdadm: /dev/sdr1 is identified as a member of /dev/md126, slot 6.<br>
      mdadm: /dev/sdu1 is identified as a member of /dev/md126, slot -1.<br>
      mdadm: /dev/sdz1 is identified as a member of /dev/md126, slot 11.<br>
      mdadm: /dev/sdx1 is identified as a member of /dev/md126, slot 9.<br>
      mdadm: /dev/sdk1 is identified as a member of /dev/md126, slot -1.<br>
      mdadm: /dev/sds1 is identified as a member of /dev/md126, slot 7.<br>
      mdadm: /dev/sdm1 is identified as a member of /dev/md126, slot 3.<br>
      mdadm: /dev/sdn1 is identified as a member of /dev/md126, slot 2.<br>
      mdadm: /dev/sdw1 is identified as a member of /dev/md126, slot 4.<br>
      mdadm: /dev/sdt1 is identified as a member of /dev/md126, slot 0.<br>
      mdadm: added /dev/sdv1 to /dev/md126 as 1<br>
      mdadm: added /dev/sdn1 to /dev/md126 as 2<br>
      mdadm: added /dev/sdm1 to /dev/md126 as 3<br>
      mdadm: added /dev/sdw1 to /dev/md126 as 4<br>
      mdadm: no uptodate device for slot 5 of /dev/md126<br>
      mdadm: added /dev/sdr1 to /dev/md126 as 6<br>
      mdadm: added /dev/sds1 to /dev/md126 as 7<br>
      mdadm: no uptodate device for slot 8 of /dev/md126<br>
      mdadm: added /dev/sdx1 to /dev/md126 as 9<br>
      mdadm: no uptodate device for slot 10 of /dev/md126<br>
      mdadm: added /dev/sdz1 to /dev/md126 as 11<br>
      mdadm: added /dev/sdq1 to /dev/md126 as -1<br>
      mdadm: added /dev/sdu1 to /dev/md126 as -1<br>
      mdadm: added /dev/sdk1 to /dev/md126 as -1<br>
      mdadm: added /dev/sdt1 to /dev/md126 as 0<br>
      mdadm: /dev/md126 assembled from 9 drives and 3 spares - not
      enough to start the array.<br>
      ---<br>
      <br>
    </p>
    <p>Can somebody explain me behavior of the array? (theory)<br>
    </p>
    <p>This is RAID-6 so after two disk are disconnected it still works
      fine. Next when third disk disconnect the array should stop as
      faulty, yes? <br>
      If array stop as faulty the data on array and third disconnected
      disk should be the same, yes?</p>
    <p><br>
    </p>
    <span style="white-space: pre-wrap">
</span>
    <pre class="moz-signature" cols="72">-- 
---
Thanks
Adam Nieścierowicz</pre>
  </body>
</html>

--------------Nu8N7iHFfx9LLx3AQLIo502T--
--------------x5UAEdID4ZkgJRK4pYXuQxG6
Content-Type: text/vcard; charset=UTF-8; name="adam_niescierowicz.vcf"
Content-Disposition: attachment; filename="adam_niescierowicz.vcf"
Content-Transfer-Encoding: base64

YmVnaW46dmNhcmQNCmZuO3F1b3RlZC1wcmludGFibGU6QWRhbSBOaWU9QzU9OUJjaWVyb3dp
Y3oNCm47cXVvdGVkLXByaW50YWJsZTpOaWU9QzU9OUJjaWVyb3dpY3o7QWRhbQ0KZW1haWw7
aW50ZXJuZXQ6YWRhbS5uaWVzY2llcm93aWN6QGp1c3RuZXQucGwNCngtbW96aWxsYS1odG1s
OlRSVUUNCnZlcnNpb246Mi4xDQplbmQ6dmNhcmQNCg0K

--------------x5UAEdID4ZkgJRK4pYXuQxG6--
