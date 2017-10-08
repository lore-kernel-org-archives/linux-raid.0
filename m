From: "John Stoffel" <john@stoffel.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Sun, 8 Oct 2017 16:57:45 -0400
Message-ID: <23002.37193.492253.120639@quad.stoffel.home>
References: <22997.8664.67459.119616@quad.stoffel.home>
        <87a81637lq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a81637lq.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "NeilBrown" == NeilBrown  <neilb@suse.com> writes:

NeilBrown> On Wed, Oct 04 2017, John Stoffel wrote:
>> Since Eli had such a horrible experience where he shrunk the
>> individual component raid device size, instead of growing the overall
>> raid by adding a device, I came up with this hacky patch to warn you
>> when you are about to shoot yourself in the foot.
>> 
>> The idea is it will warn you and exit unless you pass in the --force
>> (or -f) switch when using the command.  For example, on a set of loop
>> devices:
>> 
>> # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>> [raid4] [multipath] [faulty]
>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>> loop0p1[0]
>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>> [UUUUU]
>> 
>> # ./mdadm --grow /dev/md99 --size 128
>> mdadm: Cannot set device size smaller than current component_size of /dev/md99 array.  Use -f to force change.
>> 
>> # ./mdadm --grow /dev/md99 --size 128 -f
>> mdadm: component size of /dev/md99 has been set to 0K
>> 

NeilBrown> I'm not sure I like this.
NeilBrown> The reason that mdadm will quietly accept a size change like this is
NeilBrown> that it is trivial to revert - just set the same to a big number and all
NeilBrown> your data is still there.

This is wrong, because if you use --grow --size ### with a small
enough number, it destroys the MD raid superblock.  So again, I think
the --force option is *critical* here.  Or we need to block the size
change from going smaller than the superblock size.  Here's my test,
where I just warn if the size is going to be smaller:

    # ./mdadm --grow /dev/md99 --size 128
    mdadm: setting raid component device size from 202240 to 128 in array /dev/md99,
    this may need to be reverted if new size is smaller.
    mdadm: component size of /dev/md99 has been set to 0K

    # ./mdadm --grow /dev/md99 --size 202240
    mdadm: setting raid component device size from 0 to 202240 in array /dev/md99,
    this may need to be reverted if new size is smaller.
    mdadm: Cannot set device size in this type of array.

    # mdadm -E /dev/md99
    mdadm: No md superblock detected on /dev/md99.

So I think this argues for a much stronger check, and/or the --force
option when shrinking.  I'll re-spin my patch series into two chunks,
one just the message if changing size.  The second to require the
--force option.

And I think we need a third option to make sure the size can't be
smaller than the array superblock size as well.  Otherwise a simple
mistake trashes your array.

My current warning only patch (with whitespace damage...)

> git diff
diff --git a/Grow.c b/Grow.c
index 455c5f9..18aea63 100755
--- a/Grow.c
+++ b/Grow.c
@@ -1625,6 +1625,10 @@ int Grow_reshape(char *devname, int fd,
                return 1;
		        }

+       if (s->size != (unsigned)array.size) {
+               pr_err("setting raid component device size from %u to %llu in array %s,\nthis may need to be reverted if new size is smaller.\n",(unsigned)array.size,s->size,devname);
+       }
+
        st = super_by_fd(fd, &subarray);
	        if (!st) {
		                pr_err("Unable to determine metadata format for %s\n", devname);
				
