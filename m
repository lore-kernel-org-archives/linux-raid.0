From: Billy Crook <billycrook@gmail.com>
Subject: Re: Stupid question regarding RAID-1 access pattern
Date: Wed, 6 Jan 2010 16:13:55 -0600
Message-ID: <a43edf1b1001061413p6d3689f0u9be7bc35c8892cd5@mail.gmail.com>
References: <4B44EB58.2090400@northarc.com> <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100106213723.GA12318@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 6, 2010 at 15:37, Robin Hill <robin@robinhill.me.uk> wrote:
> I doubt this would help much really. =A0If you're reading sequential =
data
> then it's pretty much as quick to keep reading as to seek to the next
> chunk.

Could it hurt [performance]?  SSDs will only become more common, and
they haven't any seek penalty.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
