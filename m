From: David Brown <david@westcontrol.com>
Subject: Re: [PATCH 1/1] Work around gcc-4.7's strict aliasing checks
Date: Tue, 24 Jan 2012 10:18:57 +0100
Message-ID: <jflta6$vnr$1@dough.gmane.org>
References: <20120112104320.471910db@notabene.brown> <1327193360-4446-1-git-send-email-soltys@ziu.info> <4F1D57A5.7070104@redhat.com> <4F1E027A.40007@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F1E027A.40007@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/01/2012 01:59, Michal Soltys wrote:
>
> Well, IMHO the [probably] best workaround for now would be
> -fno-strict-aliasing then - which avoids warnings, ugly attribute
> [over]use, and should assure expected behavior.
>
> Say, near the top of Makefile:
>
> -CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)
> +CFLAGS = $(CWFLAGS) $(CXFLAGS) -fno-strict-aliasing -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS)

Another option is using #pragma's in the source code to turn on 
"no-strict-aliasing" - I don't know what the preferences are on #pragma 
versus Makefile options.  Personally, I prefer a #pragma in a case like 
this, as it ties the option closer to the code that requires it - but 
obviously the Linux code style preferences must be followed.


