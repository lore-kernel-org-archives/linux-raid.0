From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH -v2 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Tue, 18 Jul 2017 04:43:31 -0400 (EDT)
Message-ID: <439486871.31800565.1500367411988.JavaMail.zimbra@redhat.com>
References: <1500283627-15195-1-git-send-email-xni@redhat.com> <3d22eddd-79cc-4877-8c0d-497ea80e829b@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3d22eddd-79cc-4877-8c0d-497ea80e829b@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org, jes sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Zhilong Liu" <zlliu@suse.com>
> To: "Xiao Ni" <xni@redhat.com>, linux-raid@vger.kernel.org
> Cc: "jes sorensen" <jes.sorensen@gmail.com>
> Sent: Tuesday, July 18, 2017 12:37:32 PM
> Subject: Re: [PATCH -v2 1/1] mdadm/test: Add one test case for raid5 reshape
> 
> 
> 
> On 07/17/2017 05:27 PM, Xiao Ni wrote:
> > This case trys to allow raid5 reshape to use backwards direction.
> > It changes chunksize after reshape and stop the raid. Then start
> > the raid again.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   tests/02r5grow | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> >
> > diff --git a/tests/02r5grow b/tests/02r5grow
> > index 386e82e..64c5599 100644
> > --- a/tests/02r5grow
> > +++ b/tests/02r5grow
> > @@ -34,3 +34,16 @@ check nosync
> >   sh tests/testdev $md0 3 $[size/2] 128
> >   
> >   mdadm -S $md0
> > +
> > +# create a raid5 array and change the chunk
> > +mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3
> > --size $[size/2] $dev1 $dev2 $dev3
> > +check wait
> > +check state UUU
> > +
> 
> Hi,
>     Just my opinion, it should check the chunk-size properly if you
> wanna test 'chunk'.
>     Maybe can do following three things in a function.
> 
>  From sysfs:
> new_size=$(cat /sys/block/md0/md/chunk_size)
> if [ "$(expr 32 \* 1024)" -eq "$new_size" ]; then
> ...
> fi
> 
>  From procfs:
> # cat /proc/mdstat  | awk -F',' '/chunk/{print $2}'
> 32k chunk
> 
>  From superblock:
> mdadm -D /dev/md0 | grep "Chunk Size"
> 
>    It's important for testing based on expected environment.
> 
> > +mdadm $md0 --grow --chunk=64
> > +check reshape
> > +check wait
> 
> Here too.
> 
> > +
> > +mdadm -S $md0
> > +mdadm -As
> > +check state UUU
> 
> Also here.

Thanks for these suggestions. I'll add this check too.

Regards
Xiao
> 
> Thanks,
> -Zhilong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
