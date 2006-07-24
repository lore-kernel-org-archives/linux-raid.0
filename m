From: "Pieter Steyn" <pieterste@gmail.com>
Subject: Re: Dell PowerEdge Expandable RAID Controller 4e/Di
Date: Mon, 24 Jul 2006 21:41:43 +0200
Message-ID: <c49e66200607241241y46cd624n866ca4d2a9f9d8db@mail.gmail.com>
References: <c49e66200607240619g64acb7a9ud325e1c43be798a5@mail.gmail.com>
	 <Pine.LNX.4.56.0607241506520.13928@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0607241506520.13928@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ah!

As per Joshua's reply to one of my previous Raid questions, the
solution works in this case aswel! :


>I have a (very/embarrassingly) crude script which uses megarc >(downloaded
>directly from LSI).  It greps the output of "megarc -dispCfg -a0" for
>DEGRADED.  If it finds that then it emails me and also touches a >state
>file so it doesn't continue mailing me every 15 minutes (which is how
>often I run it).

Cheers!
