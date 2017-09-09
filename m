From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 20:41:36 +0100
Message-ID: <1789a7e9-06ab-e3d5-05bc-582bf9db59e8@youngman.org.uk>
References: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
 <e48c2cae-dd3a-f854-0030-8e2892fa183d@youngman.org.uk>
 <20170909183701.75e7f6a36gac3rsc@merlins.org>
 <6b7cbee4-562b-f127-77d8-01542f44d396@youngman.org.uk>
 <20170909191929.5q7wa42ntt3p6x32@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170909191929.5q7wa42ntt3p6x32@merlins.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/09/17 20:19, Marc MERLIN wrote:
> I know what you're trying to say, but not quite what I meant.
> You can have hash checksums over a certain amount of data, per drive.
> Those checksums would cover maybe 4KB blocks (or even 1MB) and take a
> mere 2 or 4 bytes. If your raid parity does not match, you can then
> verify the per drive checksum and figure out which drive is "wrong".
>  From there, when you repair, you know which drive's data to throw away
> and recompute.

Ah - I understand. This could well be a useful extra bit of information. 
As far as the maths is concerned then the checksum would then be an 
extra "equation" and, provided it's not equivalent to the data then it 
would enable an extra unknown to be solved. Interesting thought ...

The problem is, as I understand it (note Phil's mention of flamewars :-) 
that there are a whole bunch of things that can corrupt stripes. Not 
least if a drive accidentally writes a block in the wrong place ... at 
which point all of your drive level checks will work fine, but any 
attempt to read the affected stripes will read corrupted data :-(

Cheers,
Wol
