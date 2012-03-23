From: Alexander Peganz <a.peganz@gmail.com>
Subject: restoring array after zeroing superblocks
Date: Fri, 23 Mar 2012 10:13:09 +0100
Message-ID: <CADtmLM86Jbcu279J9L+6wuM4vUOuU86hkv3JnejWxuf-fGzWrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Due to a=A0spontaneous=A0case of major brainfart I am now the proud own=
er
of a mdadm raid6 array with zeroed superblocks. As in I zeroed the
superblocks on each and every component device. I'm really hoping
there is still a way to recover from this since there are about 6TB of
data on there I cannot afford to loose.
The data itself should still be ok since nothing was written to the
components. I think I just need a way to restore the superblocks.



So first question: does mdadm create "backup-superblocks" that should
have survived the zeroing and that can be restored somehow?
If yes: That would save my day. I'd be eternally grateful for any
instructions as to how to do that.



If no: That means I'll have to recreate the array in a way that
doesn't destroy the data on it. Here's the whole story of the array:

I'm using Ubuntu 10.04 Server. Initially the array was a raid5 created
with the mdadm version that comes with that (2.6.7.1 according to
packages.ubuntu.com). It had the following parameters:
Metadata format 0.90, chunksize 1M, parity I don't remember but I'm
guessing the default left-symmetric
Later I added some drives and wanted to reshape to raid6. That wasn't
possible with that mdadm version. So I installed a Debian package with
version 3.1.4. With that I successfully reshaped the array. Strangely
the metadata version ended up being 0.91 after that, but it worked
perfectly fine for years since then, even through -G operations.
Components are the partitions /dev/sd[c-h]4.

I did some initial research and
mdadm -C /dev/md6 -e 0.90 -n 6 -c 1M -l 6 --assume-clean -a md /dev/sd[=
c-h]4
should at least not destroy the stored data. After doing a mdadm -o
/dev/md6 for safety=A0e2fsck -fnv /dev/md6 should then tell me if the
file system is still ok without writing to the disks. mount with -r -o
ro,noload should safely mount it so I can check if everything is still
there. If the new metadata matches the old one everything should be
fine. Is this correct? Or could I end up destroying data with one of
the commands?

If it doesn't work that could mean that the layout is not correct. So
I'd probably have to try every possible sequence for the partitions
till each one is in it's correct place. Oh well, that's just 720
possible combinations, or 1440 if I have to try right-symmetric as
well :(
Is there some way to find out the correct sequence? If I take a look
at 6 locations on each partition that are 1M apart from each other (so
the parity chunks are on different drives for each location) it should
be possible to find out which ones contain data and which ones contain
the p- and the q-parity data and derive the layout from that. To do
that I'd need to know how the parity is calculated. The p-parity is
just xor as far as I know, but I don't know about the q-parity.
Incidentally, is there a simple way to print a single byte that was
read with dd to the console in binary?



Assuming all of this works and I get the array to start with the data
intact: the array size was smaller than the components. So I don't
know if the parity data in the area that was unused is correct. If I
get the array working again, will this be a problem? Or will the
parity information just get recalculated for those chunks?



I really hope someone here will be able to help me with this! I'm
grateful for any assistance you can provide!
Sincerely,
Alexander Peganz
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
