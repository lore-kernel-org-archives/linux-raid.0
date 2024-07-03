Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFEC155A39
	for <linux-raid@vger.kernel.org>; Wed,  3 Jul 2024 10:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720001777; cv=none; b=qsP8Vvks4fbdJPS3kxnKHLtCrWc8Ig58Mq3wczJY1BTSzvposoifU34ww+Fee6G1/+1yqd7muvUoEmZrdfaLvA7WrjSJnurBdLtmNfOrkRA46hrW2AGQIXp9980lr9pfFsD3oZNhiojrldZUCoqZZpNfptGQ84Uu1e4rlmZBk2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720001777; c=relaxed/simple;
	bh=zNe+Ovkg0TGmozTtLJs7JbS01hvcqOSqbuq1GR7zsc4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OexYKYl8EB3poA32uBkbblt3Ot7lOJlPotiQIgREFEF+8ls/GZtit6ufP5GLHcCmK6/tZDeuMLbz/w/4AL9ERfeuGNcPv9LUd6eSMfIqw2zETmWNsVS2TkHniQjk5IaBL0UjFlPkg32nSPDisweZ4CTtw040VP/c21LbteTJVY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WhsbsK2M; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WhsbsK2M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720001777; x=1751537777;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zNe+Ovkg0TGmozTtLJs7JbS01hvcqOSqbuq1GR7zsc4=;
  b=WhsbsK2MMKUrnyoeRqVSemVKyy9DUjrv+pn3wCisMYU3NRRdUgbp+EBk
   /ln6CsBfxzN6YOxbenw3JR8cSnKj1ud3qoF8yW0WcqGL7CseTQglVGPwb
   jUNgUtbuCTE3YPRwILU2o9Y9OOqfqcCU/hK03+4l4vyNzNjCIdcAISzZ7
   XNKWKuuqUCR8VtHl1nuCNpPjZIYvcRhG1o+9ZIwXoJfMiQsySpGJIEhjH
   qZbAqCpBbLLV5goLSc80xRhFD3iLbhFRlY9uZ1PpVvKoCAIxishu0CGoQ
   dWoWYWDHCwZe6KPE/7bh6w9/jm/YtFLUPlMrCWzvNGbFrBwg81Ry7vnug
   Q==;
X-CSE-ConnectionGUID: gc1RtPYVR0evIe+6vA8VDw==
X-CSE-MsgGUID: 5STNDjJuRLKzec7O5DSjxA==
X-IronPort-AV: E=McAfee;i="6700,10204,11121"; a="28617814"
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="28617814"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 03:16:16 -0700
X-CSE-ConnectionGUID: QXvZBQU7SUyRUT6vSG7xrg==
X-CSE-MsgGUID: IEhR91xqRxWaxjL7nWudhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,181,1716274800"; 
   d="scan'208";a="46273768"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2024 03:16:14 -0700
Date: Wed, 3 Jul 2024 12:16:10 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Adam Niescierowicz <adam.niescierowicz@justnet.pl>
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID6 12 device assemble force failure
Message-ID: <20240703121610.00001041@linux.intel.com>
In-Reply-To: <20240703094253.00007a94@linux.intel.com>
References: <56a413f1-6c94-4daf-87bc-dc85b9b87c7a@justnet.pl>
	<20240701105153.000066f3@linux.intel.com>
	<25cb6321-9e61-405f-abd7-2187236af62a@justnet.pl>
	<20240702104715.00007a35@linux.intel.com>
	<347003bc-28f1-41e9-b5c4-a2cba5a4475c@justnet.pl>
	<20240703094253.00007a94@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 3 Jul 2024 09:42:53 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Tue, 2 Jul 2024 19:47:52 +0200
> Adam Niescierowicz <adam.niescierowicz@justnet.pl> wrote:
> 
> > >>>> What can I do to start this array?    
> > >>>    You may try to add them manually. I know that there is
> > >>> --re-add functionality but I've never used it. Maybe something like that
> > >>> would
> > >>> work:
> > >>> #mdadm --remove /dev/md126 <failed drive>
> > >>> #mdadm --re-add /dev/md126 <failed_drive>    
> > >> I tried this but didn't help.    
> > > Please provide a logs then (possibly with -vvvvv) maybe I or someone else
> > > would help.    
> > 
> > Logs
> > ---
> > 
> > # mdadm --run -vvvvv /dev/md126
> > mdadm: failed to start array /dev/md/card1pport2chassis1: Input/output error
> > 
> > # mdadm --stop /dev/md126
> > mdadm: stopped /dev/md126
> > 
> > # mdadm --assemble --force -vvvvv /dev/md126 /dev/sdq1 /dev/sdv1 
> > /dev/sdr1 /dev/sdu1 /dev/sdz1 /dev/sdx1 /dev/sdk1 /dev/sds1 /dev/sdm1 
> > /dev/sdn1 /dev/sdw1 /dev/sdt1
> > mdadm: looking for devices for /dev/md126
> > mdadm: /dev/sdq1 is identified as a member of /dev/md126, slot -1.
> > mdadm: /dev/sdv1 is identified as a member of /dev/md126, slot 1.
> > mdadm: /dev/sdr1 is identified as a member of /dev/md126, slot 6.
> > mdadm: /dev/sdu1 is identified as a member of /dev/md126, slot -1.
> > mdadm: /dev/sdz1 is identified as a member of /dev/md126, slot 11.
> > mdadm: /dev/sdx1 is identified as a member of /dev/md126, slot 9.
> > mdadm: /dev/sdk1 is identified as a member of /dev/md126, slot -1.
> > mdadm: /dev/sds1 is identified as a member of /dev/md126, slot 7.
> > mdadm: /dev/sdm1 is identified as a member of /dev/md126, slot 3.
> > mdadm: /dev/sdn1 is identified as a member of /dev/md126, slot 2.
> > mdadm: /dev/sdw1 is identified as a member of /dev/md126, slot 4.
> > mdadm: /dev/sdt1 is identified as a member of /dev/md126, slot 0.
> > mdadm: added /dev/sdv1 to /dev/md126 as 1
> > mdadm: added /dev/sdn1 to /dev/md126 as 2
> > mdadm: added /dev/sdm1 to /dev/md126 as 3
> > mdadm: added /dev/sdw1 to /dev/md126 as 4
> > mdadm: no uptodate device for slot 5 of /dev/md126
> > mdadm: added /dev/sdr1 to /dev/md126 as 6
> > mdadm: added /dev/sds1 to /dev/md126 as 7
> > mdadm: no uptodate device for slot 8 of /dev/md126
> > mdadm: added /dev/sdx1 to /dev/md126 as 9
> > mdadm: no uptodate device for slot 10 of /dev/md126
> > mdadm: added /dev/sdz1 to /dev/md126 as 11
> > mdadm: added /dev/sdq1 to /dev/md126 as -1
> > mdadm: added /dev/sdu1 to /dev/md126 as -1
> > mdadm: added /dev/sdk1 to /dev/md126 as -1
> > mdadm: added /dev/sdt1 to /dev/md126 as 0
> > mdadm: /dev/md126 assembled from 9 drives and 3 spares - not enough to 
> > start the array.
> > ---  
> 
> Could you please share the logs with from --re-add attempt? In a meantime I
> will try to simulate this scenario.
> > 
> > Can somebody explain me behavior of the array? (theory)
> > 
> > This is RAID-6 so after two disk are disconnected it still works fine. 
> > Next when third disk disconnect the array should stop as faulty, yes?
> > If array stop as faulty the data on array and third disconnected disk 
> > should be the same, yes?  
> 
> If you will recover only one drive (and start double degraded array), it may
> lead to RWH (raid write hole).
> 
> If there were writes during disks failure, we don't know which in flight
> requests completed. The XOR based calculations may leads us to improper
> results for some sectors (we need to read all disks and XOR the data to get
> the data for missing 2 drives).
> 
> But.. if you will add again all disks, in worst case we will read outdated
> data and your filesystem should be able to recover from it.
> 
> So yes, it should be fine if you will start array with all drives.
> 
> Mariusz
> 


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

And I failed to start it, sorry. It is possible but it requires to work with
sysfs and ioctls directly so much safer is to recreate an array with
--assume-clean, especially that it is fresh array.

Thanks,
Mariusz
