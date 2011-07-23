From: maurice <mhilarius@gmail.com>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Fri, 22 Jul 2011 21:31:56 -0600
Message-ID: <4E2A40AC.8080107@gmail.com>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se> <4E280AEF.4020801@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E280AEF.4020801@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/21/2011 5:18 AM, Stan Hoeppner wrote:
> ..Ok. Pol, keep in mind that all drives must be identical size when 
> creating an array on raw disks. 
That always makes me nervous.
I have seen the case before where a drive has been "kicked out" and when 
you go to add it back, it is refused as "too small"
Grown defects have shrunk the device.

I find it is safer to make one big partition on each device, and make 
this a bit smaller than the device.

-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
