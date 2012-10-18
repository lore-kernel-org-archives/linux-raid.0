From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Thu, 18 Oct 2012 15:28:17 -0600
Message-ID: <4A082A23-1842-473B-97A5-1F582F05D34E@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com> <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com> <CADNH=7GaGCLdK2Rk_A6vPN+Th0z0QYT7mRV0KJH=CoAffuvb6w@mail.gmail.com> <D5D49452-3E33-4440-91A2-88F1F2E329D8@colorremedies.com> <CADNH=7G0d+7-Y5fwimV6U_u8ep1BAWzFP0jQJOm4RmAkk0urXQ@mail.gmail.com> <507FEE52.50103@hardwarefreak.com> <CADNH=7FKd9LuUzwnQ7W4Evo_PzGRjY8nK6u1R3AMvzq17FMe=w@mail.gmail.com> <CADNH=7HEBDGrN+2SpLB30mAN0nW0ky=KGwCgnxeY4OSejFr1yw@mail.gmail.com> <3286E6F7-0982-4A87-A83C-5D78B22EE437@colorremedies.com> <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HqAweunG0wBG5-Ut5ECxt0zpvQaoFS=FhW=g4Sj9Rmug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 18, 2012, at 2:17 PM, Mathias Bur=E9n wrote:

> There's no more dying drives in the array, 2 out of 7 died, they are
> on RMA soon. (when I can get to the post office).

Right but 2 of those 7 you're saying gave you no warning they were abou=
t to die, which means you have 5 of 7 which could easily do the same th=
ing any moment now. For having such cheap drives you'd think you could =
have at least one on standby, hotspare or not.

You realize that WDC is within their right, if they knew you were using=
 raid6 with these drives, refusing the RMA? These are not raid5/6 drive=
s. They're not 24x7 use drives.

Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
