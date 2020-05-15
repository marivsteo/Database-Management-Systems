using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Configuration;
using System.Data.Entity.Design.PluralizationServices;
using System.Globalization;

namespace lab2DBMS
{
    public partial class Form1 : Form
    {

        SqlConnection dbConn;
        SqlDataAdapter daCountries, daParticipants;
        DataSet ds;
        SqlCommandBuilder cb;
        BindingSource bsCountries, bsParticipants;

        string con = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        string select1 = ConfigurationManager.AppSettings["select1"];
        string select2 = ConfigurationManager.AppSettings["select2"];
        string table1 = ConfigurationManager.AppSettings["table1"];
        string table2 = ConfigurationManager.AppSettings["table2"];
        string foreignkeyrelation = ConfigurationManager.AppSettings["foreignkeyrelation"];
        string column1 = ConfigurationManager.AppSettings["column1"];


        public Form1()
        {
            InitializeComponent();
            CultureInfo ci = new CultureInfo("en-us");
            PluralizationService ps = PluralizationService.CreateService(ci);
            string text = ps.Pluralize(table2);
            label1.Text = text.ToUpper();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            daParticipants.Update(ds, table2);
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            dbConn = new SqlConnection(con);
            ds = new DataSet();
            daCountries = new SqlDataAdapter(select1, dbConn);
            daParticipants = new SqlDataAdapter(select2, dbConn);
            cb = new SqlCommandBuilder(daParticipants);
            daCountries.Fill(ds, table1);
            daParticipants.Fill(ds, table2);
            DataRelation dr = new DataRelation(foreignkeyrelation,
                ds.Tables[table1].Columns[column1],
                ds.Tables[table2].Columns[column1]);
            ds.Relations.Add(dr);

            //data binding
            bsCountries = new BindingSource();
            bsCountries.DataSource = ds;
            bsCountries.DataMember = table1;
            bsParticipants = new BindingSource();
            bsParticipants.DataSource = bsCountries;
            bsParticipants.DataMember = foreignkeyrelation;
            dgvCountries.DataSource = bsCountries;
            dgvParticipants.DataSource = bsParticipants;
        }
    }
}
