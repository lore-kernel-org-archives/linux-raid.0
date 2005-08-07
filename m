From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Getting md0 to come back automatically
Date: Sun, 7 Aug 2005 16:48:42 +1000
Message-ID: <17141.44746.1917.952435@cse.unsw.edu.au>
References: <6d5bedd8050806171140e7f9dd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ewan Grantham on Saturday August 6
Sender: linux-raid-owner@vger.kernel.org
To: Ewan Grantham <ewan.grantham@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday August 6, ewan.grantham@gmail.com wrote:
> I'm running mdadm 1.9.0 on a Debian build (using coLinux 0.7.1), and
> have the following for my /etc/mdadm/mdadm.conf:
> 
> ARRAY /dev/md0 level=raid5 num-devices=4
> UUID=777b15e6:6791bb61:96a9c2f4:80e2f7bf
> DEVICE /dev/cobd3,/dev/cobd4,/dev/cobd5,/dev/cobd6
                   ^          ^          ^

get rid of the commas.

NeilBrown



> 
> I can rebuild the array manually after a restart using:
> 
> mdadm -A /dev/md0 /dev//cobd3 /dev/cobd4 /dev/cobd5 /dev/cobd6
> 
> but it doesn't come up automatically on it's own. Anything that y'all
> can see that's wrong with this?
> 
> Thanks,
> Ewan
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
