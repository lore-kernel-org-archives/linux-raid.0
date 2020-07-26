From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH v2] mdadm/Detail: show correct state for cluster-md array
Date: Sun, 26 Jul 2020 09:14:08 +0100
Message-ID: <5F1D3B50.8080006@youngman.org.uk>
References: <1595401905-3459-1-git-send-email-heming.zhao@suse.com>
 <7697b7eb-76f9-8102-a490-1684e5f18acf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7697b7eb-76f9-8102-a490-1684e5f18acf@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: "heming.zhao@suse.com" <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

On 22/07/20 08:20, heming.zhao@suse.com wrote:
> During I was creating patch, I found the ExamineBitmap() has memory leak issue.
> I am not sure whether the leak issue should be fixed.
> (Because when mdadm cmd finish, all leaked memory will be released).
> The IsBitmapDirty() used some of ExamineBitmap() code, and I only fixed leaked issue in IsBitmapDirty().
> 
My gut feel?

Firstly, "do things right" - it should be fixed.
Second - are you sure this code is not run while mdadm is running as a
daemon? It's all very well saying it will be released, but but mdadm
could be running for a looonnngg time.

Cheers,
Wol
