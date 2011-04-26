From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: mdadm 3.2.1 doesn't compile with gcc 4.6.0
Date: Tue, 26 Apr 2011 12:12:22 -0400
Message-ID: <BAY148-w17FD78103294F574E43B43EF990@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On Tue, 26 Apr 2011 09:00:17 +0200  wrote:
>
> Hi guys,
> mdadm.c:106:6: error: variable 'auto_update_home' set but not used [-
> Werror=unused-but-set-variable]
>

I have not grepped the source code for other instances of 'auto_update_home' so it may or may not actually be used.

If its not ever used you can try commenting out the declaration of 'auto_update_home' and then re-compile?

Lastly, you could drop the -Werror=unused-but-set-variable option, as it is turning the warning (which may happen and still compile) into an error (which when happens, will not compile).



-M
 		 	   		  