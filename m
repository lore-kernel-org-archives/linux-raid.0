From: Kasper Dupont
	<87385155133026632046@expires.04.sep.2006.kasperd.net>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 15:48:26 +0100
Message-ID: <20060303144824.GA15672@hactar.lan>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060303073016.GA662@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> grep -i ^wcache /proc/ide/hd*/settings

On the 2.6 system where I see the differences between mirrors
I get this result from above command:

/proc/ide/hde/settings:wcache                  1               0       =
        1               rw
/proc/ide/hdg/settings:wcache                  1               0       =
        1               rw

On a 2.4 system where I see no differences between mirrors I
get this result from above command:

/proc/ide/hda/settings:wcache                  0               0       =
        1               rw
/proc/ide/hdc/settings:wcache                  0               0       =
        1               rw
/proc/ide/hde/settings:wcache                  0               0       =
        1               rw
/proc/ide/hdg/settings:wcache                  0               0       =
        1               rw

So how should I interpret this?

(A copy of any replies to my email address will be appreciated).

--=20
Kasper Dupont -- Rigtige m=E6nd skriver deres egne backupprogrammer
#define _(_)"d.%.4s%."_"2s" /* This is my new email address */
char*_=3D"@2kaspner"_()"%03"_("4s%.")"t\n";printf(_+11,_+6,_,6,_+2,_+7,=
_+6);
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
