From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: New RAID-6 snapshot
Date: Tue, 30 Dec 2003 10:35:53 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1C589.3070906@zytor.com>
References: <bsrns4$uaa$1@cesium.transmeta.com> <20031230172420.GS1882@matchmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230172420.GS1882@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Fedyk wrote:
> On Tue, Dec 30, 2003 at 03:34:28AM -0800, H. Peter Anvin wrote:
> 
>>Well, I implemented read-modify-write for RAID-6, and at least on my
>>6-disk system it was a small but measurable performance *loss*.
> 
> What was your previous patch doing instead?

The published snapshots (including the latest, since I backed out 
read-modify-write) all do read-reconstruct-write.

	-hpa

