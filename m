From: "=?ISO-8859-1?Q?Jens_B=E4ckman?=" <jens.backman@gmail.com>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Wed, 28 May 2008 18:34:00 +0200
Message-ID: <95711f160805280934y77ed7d91tec5aeb531bf8013c@mail.gmail.com>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Wed, May 28, 2008 at 10:53 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> Results:
>
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt

Either the RAID 1 read speed must be wrong, or something is odd in the
Linux implementation. There's six drives that can be used for reading
at the same time, as they contain the very same data. 63MB/s
sequential looks like what you would get from a single drive.
