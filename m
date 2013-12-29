From: Phil Turmel <philip@turmel.org>
Subject: Re: raid 6 4 disk failure, improper --create leads to bad superblock
Date: Sun, 29 Dec 2013 15:33:21 -0500
Message-ID: <52C08711.2010200@turmel.org>
References: <CAG9GHm3_UNO_jZguFtGpMwMs=a3ut2FXjNWfFV9MU1nC-YJYWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9GHm3_UNO_jZguFtGpMwMs=a3ut2FXjNWfFV9MU1nC-YJYWQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Cooper tron <cooper@cobhc.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/28/2013 06:02 PM, Cooper tron wrote:
> If you could please CC me directly. TIA
> 
> I have a raid that I've recently realized is ridden with flaws. Id
> like to be able to mount it one last time to get a current backup of
> user generated data. Then rebuild it with proper hardware.

[trim /]

> I recently added 1 more drive going from 9-10. Here is where things
> get murky. We just had a killer ice storm, brownouts and power issues
> for days. Right as I was growing. So one drive (sde, at the time)
> failed during the grow. While investigating I was forced to shut down
> due to my ups screaming at me. Once power is back, I boot up and
> theres a second drive marked faulty (don't recall which). Smartctl
> told me both drives were OK. So I readded them, as they were resyncing
> 2 more got marked faulty....  There I sat with 4 drives out of the
> array (when I should have came for help). No amount of --assemble
> would start the array. I did not try any --force. All the drives
> tested as being relatively healthy so I took a chance.
> 
> I finally got the array to start with --create --raid-devices=10 /dev/sda (etc.)

--force --assemble was your only hope.

You did a --create while the devices were in an incomplete --grow state.
 You also did nothing to maintain the original metadata version, data
offset, or chunk size.  Your description implies you also left off
--assume-clean.

Your data is *gone*.

[trim /]

> I found almost an exact case scenario from some emails, where it was
> suggested to --create again with the proper permutations and the raid
> should rebuild with hopefully some data intact.  So I tried again this
> time just specifying a 64K chunk. After an 11 hour resync. I still
> have a bad superblock when trying to mount/fsck.

There's no resync time when using --assume-clean, and it is vital to
successfully performing such a parameter search.  Leave it out even
*once* and *poof*, your data is gone.

> Without any records of the order of failures, or even an old --examine
> or --detail to show me how the raid was shaped when it was running or
> its last 'sane' state. Is there any chance I will see that data again?

Nope, sorry.  Even if you had used --assume-clean, you disrupted a
--grow operation, losing the information MD needed to continue reshaping
from one layout to another.

> Happy Holidays!

Merry Christmas and Happy New Year.  My condolences on your lost data.

Phil

