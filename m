From: "Michael Schwarz" <mschwarz@multitool.net>
Subject: Re: Behavior of mdadm depending on user
Date: Tue, 3 Jul 2007 11:53:15 -0500 (CDT)
Message-ID: <2077.72.21.237.163.1183481595.squirrel@www.multitool.net>
References: <4168.72.21.237.163.1183428604.squirrel@www.multitool.net>
    <1183466429.395.44.camel@sibyl.beware.dropbear.id.au>
Reply-To: mschwarz@multitool.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1183466429.395.44.camel@sibyl.beware.dropbear.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Dall <ian@beware.dropbear.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The problem with that approach is that it opens up the applications in
question to *any parameters* unlike the setuid C program which hardcodes the
parameters to the commands.

There is still a risk the binary may be modified, but it is lower than the
risk an attacker might be able to execute arbitrary "mdadm" and "mount/umount"
commands using sudo.

-- 
Michael Schwarz

> This isn't really an answer to your question, but isn't this an ideal
> application for sudo? Make a shell script with the mdadm command(s) you
> want. And set it up so apache or whatever your web server runs as able
> to run your shell script as root without authentication.
>
> Ian
> --
> Ian Dall <ian@beware.dropbear.id.au>
>

