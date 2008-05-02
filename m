From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Can't get rid of RAID-5 mismatches
Date: Thu, 1 May 2008 19:48:02 -0700
Message-ID: <e9c3a7c20805011948q36102719hcc27e393f2735459@mail.gmail.com>
References: <20080501211933.8466.qmail@science.horizon.com>
	 <e9c3a7c20805011721s3fd9f519hd5efb19820a4542d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20805011721s3fd9f519hd5efb19820a4542d@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>, Linus Torvalds <torvalds@linux-foundation.org>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids

On Thu, May 1, 2008 at 5:21 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, May 1, 2008 at 2:19 PM, George Spelvin <linux@horizon.com> wrote:
>  [..]
>
> >  But let me just ask... the RAID-5 repair code is known to work, right?
>  >  So the situation I've got above points to some lower-level problem?
>  >  It's not just somehow forgetting to write out the corrections and
>  >  I'm seeing the same mismatches over and over again?
>  >
>  >  Any other debugging suggestions?
>
>  I can reproduce this here, and until I can track down what happened
>  the fix is reverting commit bd2ab67030e9116f1e4aae1289220255412b37fd
>  "md: close a livelock window in handle_parity_checks5".
>
>  That fix was tested to close a livelock condition for which I had a
>  reproducible test case, but I did not regression test 'echo repair >
>  sync_action'.  My fear was that this compromised re-adding a dirty
>  disk to a degraded array but that appears unaffected.
>

The repair operation is detecting the mismatch then correcting it in
memory without writing it back.  I have a potential fix that I will
send in separate thread.  I want to put it through more testing and
get it reviewed by Neil.

--
Dan
