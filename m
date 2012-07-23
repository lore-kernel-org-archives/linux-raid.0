From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums)
 to make it more robust
Date: Sun, 22 Jul 2012 23:30:01 -0500
Message-ID: <500CD349.5090500@hardwarefreak.com>
References: <1897705147.341625.1342995720661.JavaMail.root@redhat.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1897705147.341625.1342995720661.JavaMail.root@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Same issue likely.

On 7/22/2012 5:22 PM, Jaromir Capik wrote:
>>> Likewise, if the checksumming you request is implemented in
>>> md/RAID1,
> 
> Btw. I like what Roberto proposed ... this could be a completely
> independent layer having it's own device file. MD RAID1 would
> be then built on top of such safe device files. The only thing
> to be implemented directly in the RAID1 would be that immediate
> resyncing in case of discovered read error received from such
> safety layer. And this immediate resyncing could/should be
> optional ...
> 
> Jaromir.
> 

