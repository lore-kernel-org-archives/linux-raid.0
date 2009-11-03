From: mark delfman <markdelfman@googlemail.com>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Tue, 3 Nov 2009 12:11:02 +0000
Message-ID: <66781b10911030411y5bb32610lec72966f7cc09df@mail.gmail.com>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
	 <19177.14609.138378.581065@notabene.brown>
	 <4AE94D95.4060303@shiftmail.org>
	 <66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>
	 <19183.47226.529417.743975@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19183.47226.529417.743975@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks Neil,

I seem to recall that I tried this on EXT3 and saw the same results as
XFS, but with your code and suggestions I think it is well worth me
trying some more tests and reporting back....


Mark

On Tue, Nov 3, 2009 at 4:58 AM, Neil Brown <neilb@suse.de> wrote:
> On Saturday October 31, markdelfman@googlemail.com wrote:
>>
>> I am hopeful that you or another member of this group could offer so=
me
>> advice / patch to implement the print options you suggested... if so=
 i
>> would happily allocated resource and time to do what i can to help
>> with this.
>
>
> I've spent a little while exploring this.
> It appears to very definitely be an XFS problem, interacting in
> interesting ways with the VM.
>
> I built a 4-drive raid6 and did some simple testing on 2.6.28.5 and
> 2.6.28.6 using each of xfs and ext2.
>
> ext2 gives write throughput of 65MB/sec on .5 and 66MB/sec on .6
> xfs gives 86MB/sec on .5 and only 51MB/sec on .6
>
>
> When write_cache_pages is called it calls 'writepage' some number of
> times. =A0On ext2, writepage will write at most one page.
> On xfs writepage will sometimes write multiple pages.
>
> I created a patch as below that prints (in a fairly cryptic way)
> the number of 'writepage' calls and the number of pages that XFS
> actually wrote.
>
> For ext2, the number of writepage calls is at most 1536 and averages
> around 140
>
> For xfs with .5, there is usually only one call to writepage and it
> writes around 800 pages.
> For .6 there are about 200 calls to writepages but the achieve
> an average of about 700 pages together.
>
> So as you can see, there is very different behaviour.
>
> I notice a more recent patch in XFS in mainline which looks like a
> dirty hack to try to address this problem.
>
> I suggest you try that patch and/or take this to the XFS developers.
>
> NeilBrown
>
>
>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 08d2b96..aa4bccc 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -875,6 +875,8 @@ int write_cache_pages(struct address_space *mappi=
ng,
> =A0 =A0 =A0 =A0int cycled;
> =A0 =A0 =A0 =A0int range_whole =3D 0;
> =A0 =A0 =A0 =A0long nr_to_write =3D wbc->nr_to_write;
> + =A0 =A0 =A0 long hidden_writes =3D 0;
> + =A0 =A0 =A0 long clear_writes =3D 0;
>
> =A0 =A0 =A0 =A0if (wbc->nonblocking && bdi_write_congested(bdi)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wbc->encountered_congestion =3D 1;
> @@ -961,7 +963,11 @@ continue_unlock:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!clear_page_dirty_=
for_io(page))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto c=
ontinue_unlock;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 { int orig_nr_to_write =
=3D wbc->nr_to_write;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D (*writepage)(p=
age, wbc, data);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hidden_writes +=3D orig=
_nr_to_write - wbc->nr_to_write;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_writes ++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (unlikely(ret)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (re=
t =3D=3D AOP_WRITEPAGE_ACTIVATE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0unlock_page(page);
> @@ -1008,12 +1014,37 @@ continue_unlock:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0end =3D writeback_index - 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto retry;
> =A0 =A0 =A0 =A0}
> +
> =A0 =A0 =A0 =A0if (!wbc->no_nrwrite_index_update) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (wbc->range_cyclic || (range_whole =
&& nr_to_write > 0))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mapping->writeback_ind=
ex =3D done_index;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0wbc->nr_to_write =3D nr_to_write;
> =A0 =A0 =A0 =A0}
>
> + =A0 =A0 =A0 { static int sum, cnt, max;
> + =A0 =A0 =A0 static unsigned long previous;
> + =A0 =A0 =A0 static int sum2, max2;
> +
> + =A0 =A0 =A0 sum +=3D clear_writes;
> + =A0 =A0 =A0 cnt +=3D 1;
> +
> + =A0 =A0 =A0 if (max < clear_writes) max =3D clear_writes;
> +
> + =A0 =A0 =A0 sum2 +=3D hidden_writes;
> + =A0 =A0 =A0 if (max2 < hidden_writes) max2 =3D hidden_writes;
> +
> + =A0 =A0 =A0 if (cnt > 100 && time_after(jiffies, previous + 10*HZ))=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("write_page_cache: sum=3D%d cnt=3D=
%d max=3D%d mean=3D%d sum2=3D%d max2=3D%d mean2=3D%d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sum, cnt, max, sum/cnt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sum2, max2, sum2/cnt);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sum =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cnt =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 max =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 max2 =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sum2 =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 previous =3D jiffies;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0return ret;
> =A0}
> =A0EXPORT_SYMBOL(write_cache_pages);
>
>
> ------------------------------------------------------
> From c8a4051c3731b6db224482218cfd535ab9393ff8 Mon Sep 17 00:00:00 200=
1
> From: Eric Sandeen <sandeen@sandeen.net>
> Date: Fri, 31 Jul 2009 00:02:17 -0500
> Subject: [PATCH] xfs: bump up nr_to_write in xfs_vm_writepage
>
> VM calculation for nr_to_write seems off. =A0Bump it way
> up, this gets simple streaming writes zippy again.
> To be reviewed again after Jens' writeback changes.
>
> Signed-off-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> Cc: Chris Mason <chris.mason@oracle.com>
> Reviewed-by: Felix Blyakher <felixb@sgi.com>
> Signed-off-by: Felix Blyakher <felixb@sgi.com>
> ---
> =A0fs/xfs/linux-2.6/xfs_aops.c | =A0 =A08 ++++++++
> =A01 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.=
c
> index 7ec89fc..aecf251 100644
> --- a/fs/xfs/linux-2.6/xfs_aops.c
> +++ b/fs/xfs/linux-2.6/xfs_aops.c
> @@ -1268,6 +1268,14 @@ xfs_vm_writepage(
> =A0 =A0 =A0 =A0if (!page_has_buffers(page))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0create_empty_buffers(page, 1 << inode-=
>i_blkbits, 0);
>
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* =A0VM calculation for nr_to_write seems off. =A0Bu=
mp it way
> + =A0 =A0 =A0 =A0* =A0up, this gets simple streaming writes zippy aga=
in.
> + =A0 =A0 =A0 =A0* =A0To be reviewed again after Jens' writeback chan=
ges.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 wbc->nr_to_write *=3D 4;
> +
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Convert delayed allocate, unwritten or unmapped spa=
ce
> =A0 =A0 =A0 =A0 * to real space and flush out to disk.
> --
> 1.6.4.3
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
