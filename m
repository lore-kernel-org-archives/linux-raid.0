From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 10 Issue - Swapping Data from Array to Array
Date: Fri, 06 Mar 2015 07:57:05 -0500
Message-ID: <54F9A421.2020907@turmel.org>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <54F8B792.9060206@turmel.org> <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Lamby <webmaster@peter-speer.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/06/2015 05:09 AM, Stefan Lamby wrote:
> 
> 
> This is what I got right now.
> What do you recommend to do?

1) pvcreate on the new array
2) vgextend to add the new array to the volume group
3) pvmove to get the data into the new array
4) vgreduce to disconnect the old array from lvm
5) pvremove to wipe the old array's lvm meta
6) stop the old array
7) mdadm --zero-superblock to clear the old members
8) mdadm --add to put those members into the new array

Regards,

Phil Turmel

