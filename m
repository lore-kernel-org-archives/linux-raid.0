From: "Stephen Hargrove" <stephen@exitwound.org>
Subject: Re: Should I Start Over?
Date: Wed, 30 Jun 2004 13:42:19 -0500 (CDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1775.66.230.1.97.1088620939.squirrel@exitwound.org>
References: <1147.66.230.1.97.1088603162.squirrel@exitwound.org>
    <20040630165540.GA1099@percy.comedia.it>
Reply-To: stephen@exitwound.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040630165540.GA1099@percy.comedia.it>
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Luca.  Thanks for getting back with me.  Following is the information
you asked for.  Please let me know if I need to provide anything else.

Luca Berra said:
> can you try ?
> cat /proc/partitions

$ cat /proc/partitions
major minor  #blocks  name

  34     0  120060864 hdg
  34     1  120060832 hdg1
  33     0  120060864 hde
  33     1  120060832 hde1
  22     0  120060864 hdc
  22     1  120060832 hdc1
  22    64  120060864 hdd
  22    65  120060832 hdd1
   3     0   39062500 hda
   3     1      40131 hda1
   3     2     996030 hda2
   3     3    4883760 hda3
   3     4          1 hda4
   3     5    9767488 hda5
   3     6    1461883 hda6
   3     7   21912628 hda7

> and
>
> mdadm --examine /dev/hdX1
> replacing X with each of your drives


$ mdadm --examine /dev/hd[dceg]1
mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hdd1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
00000000)
mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
00000000)

--
Steve
