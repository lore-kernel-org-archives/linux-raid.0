From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Raid and LVM and LILO
Date: Tue, 18 Jul 2006 08:02:23 -0400
Message-ID: <44BCCDCF.9070707@waldoware.com>
References: <44BC21B6.1080507@minicom.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44BC21B6.1080507@minicom.com.br>
Sender: linux-raid-owner@vger.kernel.org
To: Du <eduardo@minicom.com.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Du,

Did you create a /boot partition?  /boot cannot be on LVM (AFAIK), and 
can be a regular partition or raid1.  HTH.

Paul

Du wrote:
> Hi, I was/am trying to install Debian Sarge r2 with 2 Sata HD's working 
> on Raid 1 via Software and in this newly MD device, I put LVM. All works 
> fine and the debian installs well, but when the LILO try to install, it 
> says me that I dont have an active partition and no matter what I do, it 
> doesnt installs....
> 
> Does anybody knows what is happening?
> 
> Is it a bad idea work with Raid via software and LVM???
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

