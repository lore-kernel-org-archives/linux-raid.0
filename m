From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH -v3 1/1] mdadm/test: Add one test case for raid5 reshape
Date: Tue, 18 Jul 2017 05:48:01 -0400 (EDT)
Message-ID: <1737265760.31810027.1500371281381.JavaMail.zimbra@redhat.com>
References: <1500368140-23563-1-git-send-email-xni@redhat.com> <e76ccf61-238e-00da-a00f-48354264c162@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e76ccf61-238e-00da-a00f-48354264c162@molgen.mpg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, Jes Sorensen <jes.sorensen@gmail.com>, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Paul Menzel" <pmenzel@molgen.mpg.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: linux-raid@vger.kernel.org, "Jes Sorensen" <jes.sorensen@gmail.com>, "Zhilong Liu" <zlliu@suse.com>
> Sent: Tuesday, July 18, 2017 5:03:11 PM
> Subject: Re: [PATCH -v3 1/1] mdadm/test: Add one test case for raid5 reshape
> 
> Dear Xiao,
> 
> 
> On 07/18/17 10:55, Xiao Ni wrote:
> > This case trys to allow raid5 reshape to use backwards direction.
> 
> s/trys/tries/
> 
> > It changes chunksize after reshape and stop the raid. Then start
> 
> stop*s* and start*s*

Thanks for pointing these errors. I should be more careful. 

> 
> > the raid again.
> > 
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > Suggested-by:  Jes Sorensen <jes.sorensen@gmail.com>
> > Suggested-by:  Zhilong Liu <zlliu@suse.com>
> > ---
> >   test           |  8 ++++++++
> >   tests/02r5grow | 16 ++++++++++++++++
> >   2 files changed, 24 insertions(+)
> > 
> > diff --git a/test b/test
> > index 87e2df2..51da2dc 100755
> > --- a/test
> > +++ b/test
> > @@ -320,6 +320,14 @@ check() {
> >   		grep -sq "inactive" /proc/mdstat ||
> >   			die "array is not inactive!"
> >   		;;
> > +	# It only can be used when there is only one raid
> > +	chunk )
> > +		chunk_size=`cat /proc/mdstat  | awk -F',' '/chunk/{print $2}' | awk
> > '{print $1}' | sed s/k//g`
> > +		if [ $chunk_size -ne $2 ]; then
> > +			echo >&2 "chunksize is not right"
> 
> Maybe output the two different values?
> 
>  > chunksize is not right. It should be … but is ….

Sure, it's better to give the values. 
> 
> > +			exit 1
> > +		fi
> > +		;;
> >   	* )
> >   		die "unknown check $1"
> >   		;;
> > diff --git a/tests/02r5grow b/tests/02r5grow
> > index 386e82e..20db4cd 100644
> > --- a/tests/02r5grow
> > +++ b/tests/02r5grow
> > @@ -34,3 +34,19 @@ check nosync
> >   sh tests/testdev $md0 3 $[size/2] 128
> >   
> >   mdadm -S $md0
> > +
> > +# create a raid5 array and change the chunk
> > +mdadm -CR $md0 --level raid5 --metadata=1.1 --chunk=32 --raid-disks 3
> > --size $[size/2] $dev1 $dev2 $dev3
> > +check wait
> > +check state UUU
> > +check chunk 32
> > +
> > +mdadm $md0 --grow --chunk=64
> > +check reshape
> > +check wait
> > +check chunk 64
> > +
> > +mdadm -S $md0
> > +mdadm -As
> > +check state UUU
> > +check chunk 64
> 
> Do you need to run `mdadm -S $md0` after the assembly again?

Yes, it should be stopped again.

Regards
Xiao
> 
> 
> Kind regards,
> 
> Paul
> 
