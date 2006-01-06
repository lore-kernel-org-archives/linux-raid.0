From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 06 Jan 2006 11:05:35 -0800
Message-ID: <43BEBF7F.2060701@h3c.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>	 <87oe2r2d93.fsf@rimspace.net> <fd8d0180601050321k19f12f53r@mail.gmail.com> <43BE3C99.4050706@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43BE3C99.4050706@ieee.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Slightly off-topic, but:

Simon Valiquette wrote:
> Francois Barre a =E9crit :


>   On production server with large RAID array, I tends to like very
> much XFS and trust it more than ReiserFS (I had some bad experience
> with ReiserFS in the past).  You can also grow a XFS filesystem live,
> which is really nice.

I didn't know this until recently, but ext2/3 can be grown online as
well (using 'ext2online'), given that you create it originally with
enough block group descriptor table room to support the size you're
growing too.

=46rom the man page for mke2fs:

-E extended-options
       Set  extended options for the filesystem.  Extended options are
       comma separated, and may take  an  argument  using  the  equals
       (=92=3D=92) sign.  The -E option used to be -R in earlier versio=
ns of
       mke2fs.  The -R option is still accepted for backwards compati-
       bility.   The following extended options are supported:
             stride=3Dstripe-size
                   Configure  the  filesystem  for  a  RAID array with
                   stripe-size filesystem blocks per stripe.

             resize=3Dmax-online-resize
                   Reserve  enough  space  so  that  the  block  group
                   descriptor  table  can grow to support a filesystem
                   that has max-online-resize blocks.

I have done it, and it works.

-Mike

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
