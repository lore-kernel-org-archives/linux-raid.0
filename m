From: Phil Turmel <philip@turmel.org>
Subject: Re: md prefered minor has been renumbered
Date: Mon, 28 Nov 2016 17:06:27 -0500
Message-ID: <4f363ae1-fed6-5e9f-f28a-43138383d783@turmel.org>
References: <BC4985417D7F7B49B9AB545333BDB61B191FE1A2@Exchange-MBX1.esf.edu>
 <BC4985417D7F7B49B9AB545333BDB61B191FE1BC@Exchange-MBX1.esf.edu>
 <583C8D73.5060406@youngman.org.uk>
 <7b7ed841-7fe7-627d-bdb5-edb8c7d6a894@turmel.org>
 <583C95F5.9000701@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <583C95F5.9000701@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/28/2016 03:39 PM, Wols Lists wrote:
> I did say IME :-)

(-:

>> Most modern systems have two copies of mdadm.conf.  One in the initramfs
>> so you can boot a root filesystem that is inside an array, and the other
>> in your root filesystem to assemble everything else.
> 
> Mine don't appear to have any ... and when I've tried to create one, it
> was ignored. Of course, that doesn't rule out incompetence on my part
> :-) But it means the defaults are perfectly okay for me :-) and probably
> most people most of the time ...

If you create an mdadm.conf file, and *don't* put it in your initramfs,
and are using a distro that assembles in the initramfs, your mdadm.conf
file will be ignored *during* *boot*.  But then used any other time
after boot.  If you just left it there, the next kernel upgrade or
package that triggered a new initramfs would have picked it up.  And
"magically" applied those array numbers on your next boot.

> I think I created several of my arrays as md0/1/2. And they stayed that
> way for a little while before deciding to renumber.

Sounds like your distro changed its initramfs around that time.

Phil
