From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: md extension to support booting from raid whole disks.
Date: Tue, 28 Apr 2009 10:36:34 -0700
Message-ID: <49F73EA2.3020803@zytor.com>
References: <1240574900.4507.2076.camel@ezra>	<87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com> <87ljplnmrw.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljplnmrw.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> 
> And how do you create a raid-1 partition on a whole disk raid?
> 

What you're asking for is a partitioning layer somehow hidden away
inside md.  This is about as intelligent as Dick Cheney.  We already
have partitioning layers, use them.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

