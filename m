From: Kevin Corry <kevcorry@us.ibm.com>
Subject: Re: 2.6.10-ac10 + 2.6.10udm1 + latest evms => not nice
Date: Fri, 21 Jan 2005 12:04:56 -0600
Message-ID: <200501211204.56232.kevcorry@us.ibm.com>
References: <87brbinaey.87acr2naey@878y6mnaey.message.id> <20050121144738.GM25714@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <evms-devel-admin@lists.sourceforge.net>
In-Reply-To: <20050121144738.GM25714@marowsky-bree.de>
Content-Disposition: inline
Sender: evms-devel-admin@lists.sourceforge.net
Errors-To: evms-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:evms-devel@lists.sourceforge.net>
List-Help: <mailto:evms-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/evms-devel>,
	<mailto:evms-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=evms-devel>
To: evms-devel@lists.sourceforge.net
Cc: Lars Marowsky-Bree <lmb@suse.de>, syrius.ml@no-log.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 21 January 2005 8:47 am, Lars Marowsky-Bree wrote:
> On 2005-01-21T15:13:26, syrius.ml@no-log.org wrote:
> > Don't know if it's related to evms or to dm.
> > kernel is a 2.6.10-ac10 + 2.6.10-udm1 + evms kernel patches.
> > (bd_claims + dm bbr + dm multipath)
> >
> > Here is the nice welcome message I've just got :)
>
> This looks like md on DM breakage, which Jens has just fixed in our
> kernel. I'm not sure whether he has submitted it upstream yet, but you
> can give it a try.
>
> Does the attached patch apply & fix the problem for you?

>    If md resides on top of a driver using bio_clone() (such as dm), it will
>    oops the kernel due to md submitting a botched bio that has a veclist but
>    doesn't have bio->bi_max_vecs set.

Is there a specific scenario that causes the kernel to oops if an MD device is 
made of DM devices? EVMS has been using this kind of configuration for a 
couple years, and we've never noticed a problem with it. Also, syrius 
mentioned on IRC that this problem only started occurring with -ac10, and 
that -ac8 worked fine. I'm checking out the diffs between those two versions 
to see what else might have changed.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://evms.sourceforge.net/


-------------------------------------------------------
This SF.Net email is sponsored by: IntelliVIEW -- Interactive Reporting
Tool for open source databases. Create drag-&-drop reports. Save time
by over 75%! Publish reports on the web. Export to DOC, XLS, RTF, etc.
Download a FREE copy at http://www.intelliview.com/go/osdn_nl
_______________________________________________
Evms-devel mailing list
Evms-devel@lists.sourceforge.net
To subscribe/unsubscribe, please visit:
https://lists.sourceforge.net/lists/listinfo/evms-devel
