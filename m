From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [PATCH] mdadm 2.5 (Was: ANNOUNCE: mdadm 2.5 - A tool for managing Soft RAID under Linux)
Date: Wed, 31 May 2006 10:18:01 -0700 (PDT)
Message-ID: <20060531171801.56459.qmail@web50208.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>short swap16(short in)
>{
>        int i;
>        short out=0;
>        for (i=0; i<4; i++) {
>                out = out<<8 | (in&255);
>                in = in >> 8;
>        }
>        return out;
>}

Shouldn't that be "for (i=0; i<2; i++) {..." ? 

I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
