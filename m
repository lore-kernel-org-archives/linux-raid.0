From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: New RAID-6 snapshot
Date: Tue, 30 Dec 2003 10:43:36 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031230184336.GU1882@matchmail.com>
References: <bsrns4$uaa$1@cesium.transmeta.com> <20031230172420.GS1882@matchmail.com> <3FF1C589.3070906@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3FF1C589.3070906@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Dec 30, 2003 at 10:35:53AM -0800, H. Peter Anvin wrote:
> Mike Fedyk wrote:
> >On Tue, Dec 30, 2003 at 03:34:28AM -0800, H. Peter Anvin wrote:
> >
> >>Well, I implemented read-modify-write for RAID-6, and at least on my
> >>6-disk system it was a small but measurable performance *loss*.
> >
> >What was your previous patch doing instead?
> 
> The published snapshots (including the latest, since I backed out 
> read-modify-write) all do read-reconstruct-write.

Does that mean that RRW (as the name seems to imply) would need to read the
entire stripe before it could write back the updated stripe compared to a
partial read with RMW? 
