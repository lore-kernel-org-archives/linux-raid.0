From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: recovering from raid5 corruption
Date: Mon, 30 Apr 2012 08:29:36 +0200
Message-ID: <4F9E3150.6070001@computer.org>
References: <4F9DC2E5.1090509@gmail.com> <20120430085257.65d19c20@notabene.brown> <4F9DCEC6.1050109@gmail.com> <20120430094546.4702be0a@notabene.brown> <4F9DE0EC.6080401@gmail.com> <20120430110959.561b1a4f@notabene.brown> <4F9DE732.30009@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9DE732.30009@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaya Potter <spotter@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 30/04/12 03:13, Shaya Potter wrote:
> On 04/29/2012 09:09 PM, NeilBrown wrote:
>> If you were using 3.3.1, 3.3.2, or 3.3.3 when this happened, then I
>> know what
>> caused it and suggest upgrading to 3.3.4.
>
> dont think so. main disk died, so plugged a new main disk in and
> installed ubuntu 12.04 server on it, but it wasn't playing nice, so
> turned around and installed debian squeeze and thats when I noticed the
> issue. debian is running 2.6.32. Ubuntu is running some 3.something, but
> unsure which one.

Ubuntu 12.04 includes a 3.2.0-based kernel.

The issue was introduced in commit c744a65c1e2d59acc54333ce8 (included 
in 3.3-rc7) and fixed by commit 30b8aa9172dfeaac6d77897c67ee9f9fc574cdbb 
(included in 3.4-rc1). The trouble is that the faulty commit was 
submitted to stable, with the request to backport it as far as 
practicable ("This is suitable for any stable kernel (though there might 
be some conflicts with obvious fixes in earlier kernels)").

I haven't checked, but I'm fairly sure that the Ubuntu 12.04 kernel does 
indeed include the faulty commit and does not yet have the fix (as the 
fix wasn't upstreamed until last week).

HTH, Jan
