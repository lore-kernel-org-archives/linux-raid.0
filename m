From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 09:23:52 -0700
Message-ID: <CAFCYAsfWTC+Yjkh-XO89M44bxt_7cjBB6kT+xdEfrr4L9QPZRw@mail.gmail.com>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
	<16639206.20.1364400094382.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16639206.20.1364400094382.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And yet I have this output from /proc/mdstat:

md1 : active raid1 sdb3[1] sda3[0]
      288567164 blocks super 1.1 [2/2] [UU]
      bitmap: 3/3 pages [12KB], 65536KB chunk

It is very strange. the responsiveness on small file i/o tends to
support the notion that this mirror really has a 64MB chunk size. This
is practically an order of magnitude larger than what is prudent. The
iowait on simple things like a sync or writing out small files seems
to support what mdstat is reporting. Of course, I'd like to change
this but how to do so without breaking the RAID or risking data is not
obvious.

--Jeff



On Wed, Mar 27, 2013 at 9:01 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.ne=
t> wrote:
> From the manual
>
>        -c, --chunk=3D
>               Specify  chunk size of kibibytes.  The default when cre=
ating an array is 512KB.  To ensure compatibility with ear=E2=80=90
>               lier versions, the default when Building and array with=
 no persistent metadata is 64KB.  This is  only  meaningful
>               for RAID0, RAID4, RAID5, RAID6, and RAID10.
>
> meaning - chunk size isn't relevant to a mirror
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
