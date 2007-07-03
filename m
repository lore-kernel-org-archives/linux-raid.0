From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: Behavior of mdadm depending on user
Date: Tue, 03 Jul 2007 22:10:29 +0930
Message-ID: <1183466429.395.44.camel@sibyl.beware.dropbear.id.au>
References: <4168.72.21.237.163.1183428604.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4168.72.21.237.163.1183428604.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: mschwarz@multitool.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2007-07-02 at 21:10 -0500, Michael Schwarz wrote:
> This ia just a couple of quick questions.
> 
> I'm charged with developing a prototype application that will assemble and
> mount a hot-swapped drive array, mount it, transfer files to it, unmount it,
> and stop the array. And it is an application delivered by a local webserver
> (don't ask).
> 
> I don't want to do any of the incredibly stupid acts of making madadm and
> mount/umount setuid root, nor do I want to run the webserver as root.
> 
> Instead, I took the slightly less stupid approach of invoking madadm and
> mount/umount with a hardcoded C application that is setuid root. (We can
> debate the stupidity of this -- I know it isn't best, but it is fast and less
> stupid than the alternatives presented above).

This isn't really an answer to your question, but isn't this an ideal
application for sudo? Make a shell script with the mdadm command(s) you
want. And set it up so apache or whatever your web server runs as able
to run your shell script as root without authentication. 

Ian
-- 
Ian Dall <ian@beware.dropbear.id.au>
