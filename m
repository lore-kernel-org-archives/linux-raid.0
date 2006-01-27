From: Neil Brown <neilb@suse.de>
Subject: Re: raid not creating
Date: Sat, 28 Jan 2006 08:10:52 +1100
Message-ID: <17370.35932.856350.327787@cse.unsw.edu.au>
References: <57285.192.55.52.1.1138383357.squirrel@bugs.osu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wade Pinkston on Friday January 27
Sender: linux-raid-owner@vger.kernel.org
To: Wade Pinkston <blata@bugs.osu.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday January 27, blata@bugs.osu.edu wrote:
> 
> 
> # mdadm --create --verbose /dev/md4 --level=1 --raid-devices=2 /dev/hde3
> /dev/hdg3
> mdadm: /dev/hde3 appears to contain an ext2fs file system
>     size=35214480K  mtime=Thu Jan 26 13:38:20 2006
> mdadm: /dev/hdg3 appears to contain an ext2fs file system
>     size=35214480K  mtime=Thu Jan 26 13:38:20 2006
> mdadm: size set to 35214400K
> Continue creating array? y
> mdadm: SET_ARRAY_INFO failed for /dev/md4: Device or resource busy

Sounds like /dev/md4 already exists.  What does
  cat /proc/mdstat
show?

NeilBrown
