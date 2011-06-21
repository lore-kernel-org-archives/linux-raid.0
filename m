From: Phil Turmel <philip@turmel.org>
Subject: Re: reaid problem at reboot
Date: Tue, 21 Jun 2011 16:18:18 -0400
Message-ID: <4E00FC8A.1050908@turmel.org>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: william L'Heureux <wil_c_will@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi William,

On 06/21/2011 09:14 AM, william L'Heureux wrote:
> Hi,
> 
> before we start, please note that im not a pro at mdadm or lvm, and dont now the full terminology neither the full how it works.

That's OK.  We'll help as we can.

> 1 week ago, 1 of my raid6 went wrong. it didnt have any superblock anymore. I know all the drives that belongs to that raid but 
> i 
>  dont know the right order of the drives. I tried a python script with 
> assemble and permutation all combination possible. it then checks
> the
>  header and do a e2fsck -n to check errors. Everytime i run the script i
>  get several and different results on each run. Some say that
> the 
> order of the drives doesnt matter, i agree but withotuh superblock its 
> another story. I got another raid6 which is fine and on top of those 
> 2
>  raid6, there is a lvm. if you have any question or output you want to 
> see, please tell me and i will provide further informations as soon as i
>  can
> if you dont understand me, i apologize, im trying to be better at english everyday.

First, an overview of what working:  Please show the output of "lsdrv".

http://github.com/pturmel/lsdrv

Then, some more detail:  Please show "mdadm --detail /dev/md0 /dev/md1" and "mdadm --examine /dev/sd[abcdefghijkm]1"

Finally, please show "cat /etc/lvm/backup/*"

Phil
