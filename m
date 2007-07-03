From: Michael <michael@kmaclub.com>
Subject: Re: Behavior of mdadm depending on user
Date: Tue, 03 Jul 2007 10:28:54 -0700
Message-ID: <468A8756.4070606@kmaclub.com>
References: <4168.72.21.237.163.1183428604.squirrel@www.multitool.net>    <1183466429.395.44.camel@sibyl.beware.dropbear.id.au> <2077.72.21.237.163.1183481595.squirrel@www.multitool.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2077.72.21.237.163.1183481595.squirrel@www.multitool.net>
Sender: linux-raid-owner@vger.kernel.org
To: mschwarz@multitool.net
Cc: Ian Dall <ian@beware.dropbear.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Schwarz wrote:
> The problem with that approach is that it opens up the applications in
> question to *any parameters* unlike the setuid C program which hardcodes the
> parameters to the commands.
>
>   
Take a look at the man page for sudo.  It can limit which parameters can 
be used.  You can restrict it so that they can not execute commands with 
arbitrary arguments.



Michael

