From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Filesystem corruption on RAID1
Date: Sun, 20 Aug 2017 09:14:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1708200907440.3655@uplift.swm.pp.se>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it> <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it> <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it> <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it> <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com> <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk> <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it> <59961DD7.3060208@youngman.org.uk> <784bec391a00b9e074744f31901df636@assyoma.it> <CAAMCDefNRMuTwyXn_=3v_EWHwkjy3mhod1dLw3RQpjU=9VHNJQ@mail.gmail.com>
 <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a93cf0cc1d39c30f585eb53ed36aa4c0@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Roger Heflin <rogerheflin@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 18 Aug 2017, Gionatan Danti wrote:

> So while many (old) mismatch_cnt reports on RAID1/10 arrays where 
> dismissed as "don't bother, it's a harmless RAID1 thing", I really think 
> than some were genuine corruptions due to micro powerlosses and similar 
> causes.

After a non-clean poweroff and possible mismatch now between the RAID1 
drives, and now fsck runs. It reads from the drives and fixes problem. 
However because the RAID1 drives contain different information, some of 
the errors are not fixed. Next time anything comes along, it might read 
from a different drive than what fsck read from, and now we have 
corruption.

Wouldn't it make sense for an option where fsck can do its reads and the 
md layer would run "repair" on all stripes that fsck touches? Whatever 
information is handed off to fsck, then parity is always checked (and 
repaired) if there is a mismatch.

The problem here with issuing a "repair" action is that it might actually 
copy data from the drive that fsck didn't read from, so now even though 
fsck thought it had made everything clean in the fs, it's no longer clean 
because md "repair" copied non-clean inforamation to the drive that fsck 
looked at and deemed to be ok?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
