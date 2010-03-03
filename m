From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm question
Date: Wed, 3 Mar 2010 12:42:44 +1100
Message-ID: <20100303124244.68b00e88@notabene.brown>
References: <1352887864.2731.1267578731820.JavaMail.root@mail1>
	<214245121.2733.1267578904402.JavaMail.root@mail1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <214245121.2733.1267578904402.JavaMail.root@mail1>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Minvielle <robert@lite3d.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2 Mar 2010 19:15:04 -0600 (CST)
Robert Minvielle <robert@lite3d.com> wrote:

> 
> I am trying to setup a new raid array on a debian box, and I have not run into
> this problem before. I could not find a mdadm list, so I will ask here. If this
> is totally off topic, please disregard. 

Perfectly on-topic.

> 
> 
> I am attempting to setup a raid 6 array, but this is failing so I backing down
> to a no-frills raid 5 array. The system is Debian5, stock kernel, stock everything. 
> The mdadm is the stock debian, pulled with apt-get, version 2.6.7. 
> The machine in question has one IDE drive for linux, and 45 SATA drives. Debian
> sees all of the drives, and I have fdisked all of them with one partition of type
> fd (Linux autodetect raid). fdisk -l /dev/sd[a-z] /dev/sdaa[a-s] shows them all
> with no problems. 

Using old software on new hardware....
When using Debian, I would recommend the -testing version for new hardware....
(not that I am prepared to back-up that recommendation with support).

However I suspect Debian5 should be able to be made to work with your setup.

> 
> The issue is that when I do a 
> 
> mdadm --create /dev/md0 --level=5 --raid-devices=45 /dev/sd[a-z]1 /dev/sda[a-s]1
> 
> to create a raid array with no spares, all defaults, it returns with 
> 
> invalid number of raid devices. 

The default metadata layout has a maximum of 28 devices.  If you want more,
add
   --metadata=1.0

You won't be able to use in-kernel autodetect, but you shouldn't need to with
Debian, even at that vintage.

> 
> I have searched the web to no avail. --verbose does not increase verbosity. There
> are no debug switches (that I know of) to mdadm. log files show nothing. Leaving off
> --raid-devices=45 does nothing. Changing the number of devices just for fun does
> nothing. (45,44,43,2,whatever). I am not sure if this is a problem with this version
> in debian, the number of drives that I have, or the setup. I have done this before
> (with a few less drives) with no problems. 

I'm surprised it didn't work with '2', or did you mean "42" ?

NeilBrown

> 
> Any suggestions would be appreciated. 
> 
> Thanks. 
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

