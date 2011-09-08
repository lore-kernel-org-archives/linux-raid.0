From: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Subject: Re: freshly grown array shrinks after first reboot - major data loss
Date: Thu, 08 Sep 2011 15:44:26 +0200
Message-ID: <4E68C6BA.7020807@macroscoop.nl>
References: <4E5FA4B5.6010407@macroscoop.nl> <4E5FAEF3.60501@macroscoop.nl> <4E5FB350.3040905@redhat.com> <4E5FC495.7070909@macroscoop.nl> <4E5FCC32.6020402@redhat.com> <20110908111049.08988921@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110908111049.08988921@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 8-9-2011 3:10, NeilBrown wrote:
> So your data*should*  have been back exactly as it was.  I am at a loss to
> explain why it is not.
The array contained an LVM VG that would not activate until grown back.
After growing back,
- one ext4 LV was perfectly intact
- one other could be fsck'd back to life without any damage
- a third one could be fsck'd back with leaving some stuff in lost+found
- three others were beyond repair.

The VG was as old as the array itself; the LV's were pretty fragmented.

It looked like the ext4 superblocks were shifted. I could see the superblock
with hexdump, but mount would not. fsck first had to repair the superblock
before anything else.

So my report that data was "wiped" by the sync process was incorrect.

> You ask for 'max' and it just says 'max' to the kernel.
> The kernel needs to do the testing - and currently it doesn't.
I hope/assume this is no problem for my newly created array.
>
> Thanks for your report, and my apologies for your loss.
No need to apologize ; the limitation was documented, and I could have
upgraded the metadata without data loss, had I waited longer for advice.
And I did have off-site backups for the important stuff.

I'm just reporting this so others may be spared this experience.

Thanks,
Pim

