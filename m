From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 06:24:21 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1012300623070.27193@uplift.swm.pp.se>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James <jtp@nc.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Dec 2010, James wrote:

> Can someone point me in the right direction?
> (a) what causes these errors precisely?

dmesg should give you information if this is SATA errors.

> (c) are these errors expected in a RAID array that is heavily used?

No.

> (d) what kind of errors should I see regarding "read errors" that
> *would* indicate an imminent hardware failure?

You should look into the SMART information on the drives using smartctl.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
