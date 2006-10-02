From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Simulating Drive Failure on Mirrored OS drive
Date: Tue, 03 Oct 2006 00:20:31 +0400
Message-ID: <4521748F.7000300@tls.msk.ru>
References: <4520555B.4080000@aol.com> <4520C785.8010709@dgreaves.com> <45215240.1040301@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45215240.1040301@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: david@dgreaves.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

andy liebman wrote:
> 
>>
>> Read up on the md-faulty device.
> 
> Got any links to this? As I said, we know how to set the device as
> faulty, but I'm not convinced this is a good simulation of a drive that
> fails (times out, becomes unresponsive, etc.)

Note that 'set device as faulty' is NOT the same as `md-faulty device'.
Read mdamd(8) manpage, and see options `-l' (level) and `-p' (parity)
for create mode.

/mjt
