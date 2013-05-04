From: Drew <drew.kay@gmail.com>
Subject: Re: Help with failed raid 5
Date: Sat, 4 May 2013 14:59:00 -0700
Message-ID: <CACJz6QtCJF7pmvZvjexrrmfSOJ2KvBFxWOeOSFMvWkYprehD-Q@mail.gmail.com>
References: <51853C95.5030008@cronosx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51853C95.5030008@cronosx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frederick Gnodtke <FGnodtke@cronosx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only thing that stands out is that your create statement doesn't
jive with your disk listing. "mdadm --create /dev/md0 --assume-clean
--raid-devices=5 --level=5 /dev/sd[abdef] excludes sdc during creation
whereas the disk listing you post later doesn't mention sda.



-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
